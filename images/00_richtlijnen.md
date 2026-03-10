# Nano Banana 2 Image Generation Guidelines

## STYLE_PREFIX

```
Dark painterly fantasy illustration in the style of an oil painting. Heavy visible brushstrokes, limited muted palette with selective bold color accents. Grim weathered medieval atmosphere, cinematic composition. No text, no watermarks, no UI elements, no modern objects. Consistent 16:9 landscape framing.
```

## Area Color Palettes

When writing prompts, incorporate the palette for the scene's region:

- **Meadow / Town:** muted greens, warm ochre, grey stone, accent: blood-red (sky streak)
- **Desert:** bleached yellows, bone-white, pale blue sky, accent: harsh white sunlight
- **Forest / Cave:** deep blacks, damp moss-green, warm torch-orange, accent: silver (elven elements)
- **Tundra:** cold slate-grey, frost-blue, pale earth tones, accent: moonlight silver
- **River / Coast:** dark teal, muddy brown, grey-green vegetation, accent: white water foam
- **Mountain:** snow-white, dark granite, storm-grey clouds, accent: icy blue highlights

## First-Person Perspective & The "Dragon Reveal" Strategy

The protagonist is a dragon, but the player starts the game thinking they are a human warrior. **All scenes are shown from the protagonist's point of view — the camera is the character's eyes.** The character is NEVER shown in full. At most, subtle hints of the character's own body may be visible at the edges of the frame (a gauntleted hand gripping a ledge, a shadow cast on the ground, the tip of a tail at the bottom edge). This first-person perspective is maintained throughout the entire game.

### Phase 1 — The Unknown Warrior
**Scenes:** weideweg, smalle_kloof, heuvelachtig_land, klein_stadje, klein_stadje-2, betoverd_bos, betoverd_bos-2, ingang_grot, ingang_grot-2, grottunnel
**Visuals:** Pure first-person view. If any hint of the character is visible, show ONLY a massive armored gauntlet at the frame edge or a large shadow on the ground. Nothing that reveals non-human nature.

### Phase 2 — The Hinting Beast
**Scenes:** woestijn_start, woestijn_start-2, woestijn_oost, woestijn_droom, woestijn_oase, woestijn_geraamte, woestijn_karavaan, toendra, toendra_hinderlaag, bos_gehangene, rivier_onbegaanbaar, rivier_vlot, rivier_bergkant, rivier_strand, maisvelden
**Visuals:** Still first-person. Hints become unsettling: a clawed hand at the frame edge with dark scales visible between armor gaps. A shadow on the ground that seems too large, too inhuman. NPCs in the scene react with fear or unease, staring toward the camera. The character is never shown — only the world's reaction to them.

### Phase 3 — The Draconian Warrior
**Scenes:** mountain, smederij, bergpas_ingang, bergpas_ingang-2, bergpas_gevecht, canyon_bovenkant
**Visuals:** First-person with stronger hints. A massive clawed hand gripping rock or a weapon at the frame edge. The character's own thick armored tail visible at the bottom of the frame. A shadow clearly non-human. But still never a full view of the character.

### Phase 4 — Full Reveal
**Scenes:** drakenhol_thuis
**Visuals:** First-person view of the dragon's lair. Dragon hatchlings run toward the camera excitedly. The character's own unarmored clawed hands reach toward them — scales, talons, the full truth finally visible in the character's own limbs.

## State Variant Pairs

These scene pairs must share identical landmarks so the player recognizes the location:

- **klein_stadje / klein_stadje-2:** dolphin fountain, grand mansion, town entrance sign
- **betoverd_bos / betoverd_bos-2:** circular silver-barked forest, elven arch with statues, central clearing
- **ingang_grot / ingang_grot-2:** cave mouth, rocky trail, same mountain backdrop
- **woestijn_start / woestijn_start-2:** cave exit opening, first sand dune, same rock formation
- **bergpas_ingang / bergpas_ingang-2:** mountain pass entrance, snow-laden trees, griffons circling overhead

## Technical Requirements

- Each .md file contains a single prompt after the `**Nano Banana 2 Prompt:**` marker
- The Python script prepends STYLE_PREFIX automatically — do NOT repeat style instructions in individual prompts
- Prompts should be 4–8 sentences focusing on: composition/camera, environment details, atmosphere/lighting, key narrative elements
- Consistency is critical for state-change pairs — use the same landmarks
