import os
import re
import requests
import json
import base64
import sys

API_KEY = os.getenv("OPENROUTER_API_KEY")
MODEL = "google/gemini-3.1-flash-image-preview"  # Nano Banana 2

def load_style_prefix():
    with open("images/00_richtlijnen.md", "r") as f:
        content = f.read()
    match = re.search(r"## STYLE_PREFIX\s*```\s*(.*?)\s*```", content, re.DOTALL)
    if not match:
        print("Error: Could not find STYLE_PREFIX in 00_richtlijnen.md")
        sys.exit(1)
    return match.group(1).strip()

def generate_image(prompt, output_path):
    print(f"Generating image for: {output_path}...")
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }

    payload = {
        "model": MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "modalities": ["image", "text"],
        "image_config": {"aspect_ratio": "16:9"}
    }

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            data=json.dumps(payload)
        )

        if response.status_code != 200:
            print(f"  Error {response.status_code}: {response.text}")
            return False

        result = response.json()

        if 'choices' in result and len(result['choices']) > 0:
            message = result['choices'][0].get('message', {})

            # Check for inline_data in content array (Gemini format)
            content = message.get('content', [])
            if isinstance(content, list):
                for part in content:
                    if isinstance(part, dict) and 'inline_data' in part:
                        data = part['inline_data'].get('data', '')
                        if data:
                            with open(output_path, "wb") as f:
                                f.write(base64.b64decode(data))
                            print(f"  SUCCESS! Saved to {output_path}")
                            return True

            # Fallback: check images field (OpenRouter format)
            images = message.get('images', [])
            if images:
                image_info = images[0]
                url = ""

                if isinstance(image_info, dict):
                    if "image_url" in image_info:
                        url = image_info["image_url"].get("url", "")
                    else:
                        url = image_info.get("url", "")
                elif isinstance(image_info, str):
                    url = image_info

                if url and url.startswith('data:image'):
                    header, encoded = url.split(",", 1)
                    with open(output_path, "wb") as f:
                        f.write(base64.b64decode(encoded))
                    print(f"  SUCCESS! Saved to {output_path}")
                    return True
                elif url:
                    img_response = requests.get(url)
                    img_response.raise_for_status()
                    with open(output_path, "wb") as f:
                        f.write(img_response.content)
                    print(f"  SUCCESS! Downloaded to {output_path}")
                    return True

        print(f"  Failed to find image in response.")
        print(f"  Response: {json.dumps(result, indent=2)[:500]}")
        return False

    except Exception as e:
        print(f"  Error: {e}")
        return False

def resolve_files(args, image_dir):
    """Resolve CLI args to a list of .md filenames in image_dir.
    Accepts: scene names (weideweg), filenames (weideweg.md), or paths (images/weideweg.md).
    With no args, returns all scene .md files.
    """
    skip = {"00_richtlijnen.md", "GENERATION_GUIDELINES.md"}
    if not args:
        return sorted(f for f in os.listdir(image_dir) if f.endswith(".md") and f not in skip)
    result = []
    for arg in args:
        # Strip directory prefix and .md extension for normalization
        name = os.path.basename(arg)
        if not name.endswith(".md"):
            name += ".md"
        if name not in skip:
            result.append(name)
    return result

def main():
    if not API_KEY:
        print("Error: OPENROUTER_API_KEY environment variable not set.")
        sys.exit(1)

    style_prefix = load_style_prefix()
    image_dir = "images"
    marker = "**Nano Banana 2 Prompt:**"
    files = resolve_files(sys.argv[1:], image_dir)

    for filename in files:
        file_path = os.path.join(image_dir, filename)
        with open(file_path, "r") as f:
            content = f.read()

        if marker in content:
            scene_prompt = content.split(marker)[1].strip()
            prompt = f"{style_prefix} {scene_prompt}"

            base_name = os.path.splitext(filename)[0]
            output_path = os.path.join(image_dir, f"{base_name}.png")

            if os.path.exists(output_path):
                print(f"Skipping {output_path}, already exists.")
                continue

            generate_image(prompt, output_path)

if __name__ == "__main__":
    main()
