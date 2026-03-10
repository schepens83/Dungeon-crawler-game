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
    print(f"Testing image generation for: {output_path}...")
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

        print(f"  Status: {response.status_code}")
        result = response.json()
        print(f"  Response keys: {list(result.keys())}")

        if response.status_code == 200 and 'choices' in result and len(result['choices']) > 0:
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

            # Fallback: check images field
            images = message.get('images', [])
            if images:
                image_data = images[0]
                if isinstance(image_data, dict) and "image_url" in image_data:
                    url = image_data["image_url"].get("url", "")
                elif isinstance(image_data, dict):
                    url = image_data.get("url", "")
                else:
                    url = image_data

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

        print(f"  Failed. Full response:")
        print(json.dumps(result, indent=2))
        return False

    except Exception as e:
        print(f"  Error: {e}")
        return False

def main():
    if not API_KEY:
        print("Error: OPENROUTER_API_KEY not found.")
        return

    style_prefix = load_style_prefix()
    prompt_file = "images/weideweg.md"
    output_file = "images/weideweg_test.png"

    with open(prompt_file, "r") as f:
        content = f.read()

    marker = "**Nano Banana 2 Prompt:**"
    scene_prompt = content.split(marker)[1].strip()
    prompt = f"{style_prefix} {scene_prompt}"

    print(f"Full prompt ({len(prompt)} chars):")
    print(prompt[:200] + "...")
    print()

    generate_image(prompt, output_file)

if __name__ == "__main__":
    main()
