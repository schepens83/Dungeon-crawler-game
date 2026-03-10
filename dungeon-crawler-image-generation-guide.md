# Modernizing a CLI Dungeon Crawler with AI-Generated Images

## Overview

This document captures findings, challenges, and recommendations for adding AI-generated images to a text-based dungeon crawler game with approximately 35 scenes across 6 distinct area types. The focus is on maintaining narrative immersion, visual consistency, and believability while leveraging image-to-image (img2img) generation techniques and a strategic approach to when images are shown.

---

## Core Challenges

### Visual Consistency Across Scenes

This is probably the single biggest headache. When you describe a torch-lit stone corridor in scene 3, then return to it in scene 12, the LLM image generator has no inherent memory of what it drew before. The architecture, lighting, color palette, and style can drift wildly between generations. A player who sees "their" dungeon change appearance every time they backtrack will lose immersion instantly. You need to build a robust prompting system that carries forward visual anchors — style descriptors, color palettes, architectural details — as persistent context.

### Character and NPC Persistence

Closely related but distinct: if your game has recurring characters (a merchant, a rival, a companion), getting them to look even remotely the same across multiple generated images is extremely difficult. Hair color might shift, armor design changes, faces look completely different. This breaks the "this is a person I know" feeling that's essential for narrative engagement.

### Tone and Atmosphere Coherence

A good dungeon crawler builds atmosphere gradually — dread, wonder, claustrophobia, relief. Image generators tend to default to a "generic fantasy" look unless you're very deliberate. Worse, they can swing between photorealistic, painterly, and cartoonish depending on subtle prompt differences. If one room looks like a Diablo screenshot and the next looks like a watercolor D&D illustration, the tonal contract with the player breaks.

### Narrative Pacing vs. Generation Latency

CLI dungeon crawlers thrive on rhythm — quick decisions, tense moments, rapid exploration. If every scene transition requires 5-15 seconds of image generation, you kill the pacing. This is especially painful during combat or chase sequences where tension depends on speed. You need to think about pre-generation, caching, or generating images asynchronously while text continues.

### The "Uncanny Valley" of Fantasy

Paradoxically, adding visuals can *reduce* immersion compared to pure text. A well-written text description lets the player's imagination fill in details perfectly. A generated image that's 90% right but has weird hands on a skeleton warrior, a door that floats slightly off its hinges, or a torch flame that looks like orange cotton candy actively undermines the scene. The player goes from imagining something perfect to seeing something almost-right, which can feel worse than no image at all.

### Scene Composition and Framing

Text can describe a room from the player's perspective — "you peer around the corner and see..." — but image generators don't naturally understand POV or camera placement. Getting first-person or contextually appropriate viewpoints consistently is hard. You might describe sneaking through a narrow passage but get a wide aerial shot of a cavern.

### Descriptive Text and Image Contradictions

If your game engine generates text descriptions and images from the same scene data, they can easily contradict each other. The text says "a small wooden chest sits in the corner" but the image shows a large iron-bound chest in the center of the room. Now the player doesn't know what's canonical. You need to either derive the text *from* the image or vice versa, not generate both independently.

### Interactive Elements and Affordances

In a CLI game, the text tells you "there's a lever on the wall, a locked door, and a pile of bones." These are interactive elements. A generated image might render them ambiguously, too small to notice, or not at all. The player looks at the image and thinks "I see a lever and a door" but misses the bones — or worse, sees a window in the image that doesn't exist in the game state and tries to interact with it.

---

## Strategic Use of Images

Not every scene needs a full image. Strategic use — key story moments, new environments, boss encounters — with text carrying the rest can actually produce better immersion than wall-to-wall generated imagery of inconsistent quality.

### Categorizing When Images Earn Their Place

Not all scenes carry equal narrative weight. Think of it in tiers:

**Landmark moments** — first arrival at a major location, a dramatic reveal, a boss encounter, a story turning point (like finding a town destroyed). These deserve full, carefully crafted images. They're the ones players will remember.

**State transitions** — same location, different condition. A thriving town that is later destroyed, a flooded dungeon level that was dry before, a forest changing seasons, a temple before and after you solve its puzzle. These are ideal for img2img because the structural bones stay the same but the mood and details shift. The visual continuity actually *reinforces* the narrative impact — "this is the same place, and look what happened."

**Atmosphere setters** — entering a new biome or zone for the first time. You don't need an image for every room in the ice caves, but one establishing shot when you first descend into them carries a lot of weight. Then text handles the individual rooms within that zone.

**Everything else** — regular corridors, routine encounters, backtracking through known areas. Text is fine here, and arguably better because it keeps the pacing tight.

---

## Image-to-Image (Img2Img) Pipeline for State Changes

### How It Works for Narrative Transitions

For a town that starts thriving and is later found destroyed: generate the thriving version first as your base. Then for the destroyed version, feed that same image back in with a modified prompt and moderate denoising strength — enough to add rubble, fire damage, broken walls, but not so much that it loses the composition. The player sees the same bridge, the same market square, the same clock tower — but broken. That recognition is what makes it emotionally effective.

### Extended Applications

This pattern can be extended to all sorts of narrative beats:

- A character portrait that ages or gets battle-scarred over the game
- A map that fills in as you explore
- A keep that gets progressively fortified as you help defend it
- A tavern interior with fewer patrons after a plague event
- A throne room with different banners depending on which faction the player supported

### Denoising Strength Guidelines

The key parameter to play with is denoising strength:

- **Too low (0.2–0.3):** The change is barely visible — the town just looks slightly dirty. Useful for subtle shifts like time of day or minor wear.
- **Sweet spot (0.5–0.65):** For dramatic transformations like destruction. Clearly the same place but unmistakably changed. This is where most narrative state changes should land.
- **Too high (0.8+):** You lose the structural similarity and it might as well be a new image. Defeats the purpose of using img2img for continuity.

---

## Scene Graph Architecture with Visual States

### Modeling Locations as Stateful Nodes

Each location in the game should be modeled as a node in a scene graph with multiple visual states:

- `town_square: [thriving, under_siege, destroyed, rebuilding]`
- `dungeon_entrance: [sealed, opened, collapsed]`
- `forest_path: [spring, corrupted, cleansed]`

Each state has a prompt modifier and a reference to the base image. You pre-generate the base, then generate variants via img2img. Since all images are pre-generated, you can produce all states upfront and just display the right one at runtime — zero latency during gameplay.

### Player Choice as Visual Branching

The real magic is when you use this system to show *consequences of player choice*. If the player chose to defend the town, they see it damaged but standing. If they ignored the warning, they see it in ruins. Same base image, different img2img treatment. The visual similarity between the two outcomes makes the branching feel more real than two completely unrelated images would.

Small denoising changes can deliver big narrative payoff — the same scene with subtle differences based on decisions the player made earlier.

### Discipline: Images Serve the Narrative

With pre-generated images, you need to be disciplined about not letting the images drive the story. It's tempting to think "we have a cool destroyed town image, let's make sure the player sees it" — but the image should serve the narrative, not the other way around. If a player's choices mean they never see the destruction, that unused image is a feature, not a waste.

---

## Working With 6 Area Types

### Area Types as Visual Stylesheets

The 6 area types are the biggest lever for visual consistency. For each type — say caves, forest, town, castle, swamp, ruins — create a base style prompt that defines the palette, lighting, materials, and mood. Every scene within that area type inherits from it. That way you're not reinventing the visual language for each of the 35 scenes, you're writing variations on 6 established themes.

Think of each area type as a "visual stylesheet." The cave stylesheet might specify cool blue-grey stone, low amber torchlight, condensation on walls, tight framing. Every cave scene then adds its specifics on top: "...with an underground lake" or "...with a collapsed passage and bones." The consistency comes for free because the base prompt does the heavy lifting.

### Distinctness vs. Coherence

The area types need to look like they belong in the same game world while being immediately distinguishable. This is where having a unified art style matters more than anything. If all 6 areas share the same rendering style — say, dark painterly fantasy with limited palettes — then the differences in color temperature and composition do the work of distinguishing them. Caves feel cold and blue, the town feels warm and amber, the swamp feels green and murky, all within the same artistic voice.

If you mix styles accidentally — photorealistic swamp, anime castle, oil painting forest — the game feels like a collage rather than a world.

### Area Transitions as Story Moments

Area transitions are themselves story moments. When the player leaves the forest and enters the swamp for the first time, that's a tonal shift — the lighting changes, the palette shifts, the feeling changes. Those transition points are natural candidates for "strategic image" moments. You might not need images for every scene within an area type, but you almost certainly want one for each *first entry* into a new area.

---

## Estimating the Image Count

### Breakdown for 35 Scenes

35 scenes sounds modest, but once you factor in state variations it grows. A realistic estimate:

- **6 area type reference images** — your "stylesheets," never shown to the player but used as img2img seeds or style references.
- **~20 scenes with a single state** — corridors, transitional spaces, minor locations.
- **~10 scenes with 2 states** — before/after events.
- **~5 key scenes with 3–4 states** — major story locations like the town.

That gives roughly **60–65 images total** with a clear production pipeline. This is very manageable for pre-generation — an afternoon's work with a local Stable Diffusion setup, or a modest API bill if using a hosted service.

### Minimum Viable Image Set

A minimum viable image set consists of just the 6 area introductions plus major story beats — maybe 12–15 images total. Even stopping there, you'd already have a dramatically more immersive experience than pure text. Everything else is gravy.

---

## Practical Recommendations

### Prompting Strategy

- Create a **master style prompt** that defines the overall game aesthetic (art style, rendering approach, mood).
- Create **6 area sub-prompts** that inherit from the master and add area-specific palette, lighting, and material descriptions.
- Create **scene-specific additions** that layer on top of the area sub-prompt with details unique to that scene.
- For state transitions, create **state modifier prompts** that describe the transformation (destruction, corruption, restoration, etc.) applied via img2img.

### Character Consistency

- Generate **character reference sheets** upfront.
- Use IP-Adapter or similar conditioning techniques to maintain appearance across scenes featuring recurring characters.
- Consider LoRA fine-tuning for key characters if they appear in many scenes.

### Quality Control

- Generate multiple candidates for each scene and curate the best.
- Watch for the uncanny valley — if an image is 90% right but has distracting artifacts, it's worse than no image. Be willing to reject and regenerate.
- Review all images in sequence to catch style drift between scenes in the same area type.

### Runtime Integration

- Pre-generate all images and bundle them with the game — zero generation latency during play.
- Map scene IDs to image files with state variants: `scene_town_square_thriving.png`, `scene_town_square_destroyed.png`.
- Let the game engine select the correct state variant based on game state flags.
- Reserve text-only presentation for scenes where no image exists, maintaining pacing and letting the player's imagination work.

---

## Summary

The core philosophy is: **fewer, better images shown at narratively significant moments will always beat more images of inconsistent quality shown everywhere.** Img2img generation is the key technique for showing the world changing in response to the story, and the 6 area types provide a natural scaffolding for visual consistency. Pre-generation eliminates latency concerns entirely and allows for quality curation. The total image count of 60–65 is highly manageable, with a minimum viable set of just 12–15 images already delivering substantial immersion gains.
