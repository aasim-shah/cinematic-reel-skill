---
name: cinematic-reel
description: Use when the user uploads or names a raw vertical talking-head clip (iPhone .mov/.mp4, Roman Urdu/Hindi/English speech) to be edited into a finished reel in the house "cinematic doc" style — documentary letterbox, typed case-file HUD, evidence-board b-roll, behind-head giant word, Kalam/Tillana hand notes — or when asked to edit, recut, storyboard or render a reel "in our style" with HyperFrames.
---

# Cinematic reel (house style)

## Overview

Turns one raw talking-head clip into a premium investigative-documentary reel: a natural-skin grade, 2.39 letterbox moments, a typed `FILE 01 / TOPIC` HUD with running timecode, documentary subtitles, chapter titles with a red hand circle, a full-screen evidence board that hides bad face moments, a giant word behind the speaker's head, and Kalam/Tillana handwritten accents. One accent colour: signal red.

**Reference:** `template/` is the approved 14 s sample project; every new video must look, move and sound like it. In the author's workspace the rendered reference is `videos/style-samples/renders/sample-A-cinematic-final.mp4`.

**Requirements:** Claude Code, Node 18+ (HyperFrames runs through `npx hyperframes`), ffmpeg, and macOS for `prep-source.sh` (it uses `avconvert` to tonemap iPhone HLG). Matte, transcribe and render run locally.

The style is decided. Do not run an intent interview. Ask only what is truly unknown (for example the message, if the speech is unclear).

**REQUIRED SUB-SKILLS:** `/hyperframes`, then `/general-video`. Load `/hyperframes-core` before writing HTML and `/media-use` before touching footage, the grade or audio.

## Files

| Path | What |
|---|---|
| `template/` | working approved project: `index.html` (main timeline, all modules), `compositions/board.html` (evidence board), fonts, textures, SFX, storyboard page |
| `references/style.md` | locked tokens: palette, type, grade JSON, motion values, sound map and click budget |
| `references/modules.md` | each beat module, its element ids, how to adapt it, how to scale to 30–120 s, Face QC cover options |
| `references/effects.md` | the 12-effect library (cover story, frame break, chart grow, vertigo, couch wall, phone mockup, paper cut + doodle boil, orbit, headline wall, pull-back, zoom-through, paper tear): when to use each, how to mount it, integration rules |
| `fx/` | the effect sub-compositions (`fx/*.html`), per-effect notes (`fx/notes/`), tools (`fx/tools/make_clean_plate.py`, `clean_matte.py`) |
| `scripts/new-project.sh` | copies the template into `videos/<name>/` |
| `references/qc.md` | Audio QC and Face QC rules, recording checklist, hard-won technical notes |
| `scripts/audio-qc.sh`, `scripts/prep-source.sh` | voice analysis; HLG→SDR tonemap + 1080×1920/30 fps + voice clean-up |

Read `references/qc.md` before step 2, and `references/style.md`, `references/modules.md` and `references/effects.md` before planning beats.

## Workflow

1. **Project:** `bash .claude/skills/cinematic-reel/scripts/new-project.sh <kebab-name>`. Write `BRIEF.md` (message, language, length).
2. **Audio QC** on the raw clip: `bash .claude/skills/cinematic-reel/scripts/audio-qc.sh <clip>`. Follow the Audio QC rules in `references/qc.md` (what to flag, custom `VOICE_AF`, A/B WAVs).
3. **Prep:** `bash .claude/skills/cinematic-reel/scripts/prep-source.sh <clip> videos/<name>` gives `assets/take.mp4`.
4. **Face QC** on every frame, written to `FACE-QC.md` (rules in `references/qc.md`). Every hard range is hidden later by a board or the shutter.
5. **Transcribe** for word timings. For clips over ~40 s, offer ElevenLabs Scribe (ask once per video, because it uploads the voice): send a mono MP3 of `assets/take.mp4`, then check word onsets against audio energy, since Scribe can miss a short word. Local whisper large-v3 works but is very slow on an Intel Mac.
6. **Cut dead air:** one `<video class="take clip">` per kept range, with integer-ms timings and 0.02–0.04 s volume ramps at each edge. Alternate the track indexes so clips never share a track. Update `SEGMENTS`.
7. **Matte** for every take clip under a behind-head word: `npx hyperframes remove-background` on short subclips only (about 1.3 s of CPU per frame).
8. **Plan beats** with `references/modules.md`. Place 3–6 creative effects from `references/effects.md` on GOOD face moments that match their trigger lines, at most one every about 6–8 s. Write `STORYBOARD.md` with one `## Frame N` per beat, naming the Face QC range it hides and the effect used.
9. **Build:** adapt the template modules. Change the copy, the times and the board contents. Keep the tokens, motion and layers exactly. Apply the grade from `references/style.md` with `media-treatment`. For a long reel (about 45 s or more), the lead writes `index.html`, the cut plan and a builder brief (see `fx/BUILDER-BRIEF-example.md`), then about 4 builder agents build the scenes in one parallel wave, each linting and snapshotting its own files.
10. **Check:** `npx hyperframes lint`, then `npx hyperframes check` until it reports 0 errors.
11. **Storyboard gate:** snapshot every beat and every Face QC range. Fill `storyboard/index.html` (`PROJECT`, `BEATS`), open it, show the table in chat, and **stop until the user approves**.
12. **Render** after approval only, one render at a time: `npx hyperframes render -o renders/<name>-final.mp4 --fps 30 --quality looks`.
13. **Verify:** check the log for "lowered", then run ebur128 (about −13 to −14 LUFS, peak below −1 dB). Make a 1 fps contact sheet and spot-check the SFX levels. Report honestly.

## Quick reference

| Need | Use |
|---|---|
| Hide a bad face (hard) | evidence board (module 4), ≥ 0.15 s margin |
| Hide a short bad face (< 0.8 s) | shutter to black with the title on black (module 3), or cut it out |
| New idea in the script | chapter title (module 2) and a new `FILE nn` label |
| Name, source or statistic spoken | board item: clipping headline, index-card number, chart |
| Key closing claim | behind-head word + red rule + tag + Tillana note (module 5) |
| Side remark or reaction | one Kalam (white or ink) or Tillana (red) note, written on |
| Hook / theme line on a good face | cover story (`fx/cover-story.html`) |
| A trend or number with a direction | chart grow, drawn behind the head |
| One shock claim | vertigo (once per reel) |
| A list of 2–4 questions or options | orbit |
| Content, posting or personal brand | frame break or phone mockup |
| Public fear, news, "what people say" | headline wall |
| Creativity or personality | paper cut + doodle boil |
| Detail → big picture over a bad face | pull-back reveal |
| Joining two effects / changing chapter | zoom-through cut / paper tear |

## Common mistakes

- **Over-grading the skin.** The user rejected the first, heavier grade ("face colour a bit over"). Use the exact natural grade JSON and compare against a raw frame.
- **Too many clicks.** The user rejected 15 clicks in 14 s. Use one click per typed label, never per character or word, and keep to about one click cue per 2 s.
- **A hand note covering the face or a title glyph.** Snapshot every note at its fully written frame.
- **Clipping a hand note.** The write-on `clipPath` uses percentages of the element box. Do not give notes a fixed `width`; let them size to the text.
- **Subtitles under a title or on black.** Add the window to `HIDE`.
- **The matte picks up the background** (for example a curtain) and leaves a ghost inside the giant word. Check the behind-head frames zoomed in. Fix with a `clip-path` polygon on the `.take-fg` clip, or move the word.
- **Wrong handwriting font.** Only Kalam and Tillana. Subtitles stay IBM Plex Sans.
- **Two renders at once, or rendering from the Studio.** Always render serially from the CLI.
- **Editing a project the HyperFrames desktop app had open** without syncing first. Run `npx hyperframes catch-up <dir>` before editing; its usual changes are only `data-hf-id` stamps.
- **A headline that wraps mid-phrase or text that spills out of its box.** Shrink the font size instead; snapshot every title and board item.

## Never

- Paper-reel elements (torn paper caption strips, notebook pages, kraft), yellow sticky notes or highlighters, or the rejected "skit reel" style. (The full-sheet paper-tear transition in `fx/paper-tear.html` is allowed: the user picked it on 2026-10-16.)
- More than one accent colour, bounce/`back.out` pops, shakes, spins, or per-word caption pops.
- Real photos of real people on the board. Use SVG silhouettes only.
- Any handwriting font other than Kalam and Tillana (no Permanent Marker, Caveat, Rock Salt).
- Rendering before the storyboard is approved, or leaving a flagged bad face visible.
