# Audio QC, Face QC and technical notes

These rules apply to every video made with this skill. Script paths are relative to the skill folder (`.claude/skills/cinematic-reel/`).

## Audio QC: analyse and fix the voice

Do this for every new video, on the raw upload, before prep. The voice must sound clear, not only loud.

**Measure** with `bash scripts/audio-qc.sh <clip>`. It reports loudness, peaks, the noise level in the quietest second, the tone balance per band and the stereo layout. Also listen to the problem spots it points to.

**What to flag:**
- **Muddy or boxy:** 300 Hz more than about 11 dB above 3 kHz (the script marks it).
- **Dull, no air:** very weak 10 kHz+ band, often from mic noise cancellation or a strong denoise.
- **Noisy:** quietest second above about -50 dB (hiss, fan, AC, room tone).
- **Clipping or limiting:** windows peaking above -1 dB, or loud words that sound squashed.
- **Echo or room reverb**, harsh "s" sounds, pops, clicks, mic rubbing on clothes, or one channel silent.

**Fix:**
1. The default chain in `bash scripts/prep-source.sh` fixes the usual Lark A1 Mini sound: light denoise, -3.5 dB at 250 Hz, +3 dB at 3.5 kHz, +2.5 dB shelf at 9 kHz, de-esser, compression, -14 LUFS.
2. If the clip has a different problem, tune a custom chain and pass it as `VOICE_AF="..."` to `prep-source.sh`. Examples: a stronger `afftdn` only for real noise, `adeclick` for clicks, a stronger de-esser for harsh "s", a mono pan if one channel is silent.
3. If the result is still not clear (heavy reverb, damaged audio), tell the user and suggest Adobe Podcast "Enhance Speech" on the audio. Use the returned file as the voice.

**A/B check.** For any custom chain, make three short WAVs at -14 LUFS in the scratchpad: raw, default chain and custom chain. Open them and let the user choose. Then run `bash scripts/audio-qc.sh assets/take.mp4` and confirm: about -14 LUFS, peak below -1 dB, mud vs clarity 11 dB or less, quiet pauses. Report the numbers before and after in chat.

**Recording tips.** If the raw voice is muddy or dull, also give the user the recording checklist below for the next take.

## Face QC: hide bad face moments

Do this for every new video, on the full prepped take (`assets/take.mp4`, same timing as the raw upload), before cutting dead air or planning beats.

**How to review.** Look at every frame, not samples.
- Extract all frames at 30 fps, cropped to the face area, and tile them into contact sheets of 1 s each (for example `ffmpeg -i assets/take.mp4 -vf "crop=<face box>,scale=360:-1,tile=6x5" -fps_mode passthrough qc/sheet-%03d.jpg`). Label each sheet with its start time.
- Read every sheet. Open full-size frames for any doubtful moment.
- Keep the QC frames in the scratchpad or `qc/`, not in `assets/`.

**What to flag** (the face looks wrong to a viewer):
- Eyes closed or half-closed for longer than a normal blink (about 0.3 s or more), or a half-closed frame on a cut edge.
- Eyes off camera: reading notes, looking down or sideways, searching for words.
- Awkward expression: grimace, frown that does not fit the line, mouth frozen open, lip smack, swallow, tongue, odd mid-word face.
- Head turned away, face partly out of frame, hand covering the face, motion blur or lost focus.
- A jarring face jump at a dead-air cut (head position or expression changes sharply between the two kept ranges).

Do not flag normal fast blinks or natural small movements. Hiding those makes the edit busy.

**`FACE-QC.md`.** One row per flagged range: source start–end (seconds, frame-accurate), problem, severity (hard or mild), and the spoken words at that time (fill the words in after the Transcribe step). Add the ranges again in output time after the `SEGMENTS` are final.

**How to hide.** Cover each range, with about 0.2 s margin at each side, in this order of preference:
1. **Full-screen evidence board** (or another full-screen graphic) over the range. This is the default for hard issues. The voice continues under it. Move or add a board beat to fit, keeping the beat balance in `references/modules.md`.
2. **Shutter to black** (letterbox bars closed, title on black) for ranges shorter than about 0.8 s.
3. **Cut the range out** if it contains no needed speech (a pause, a restart or a filler).

Never hide a bad moment with a letterbox, a behind-head word, a hand note, a zoom or a caption, because the face stays fully visible. Never leave a hard issue on screen. If too many ranges make the edit busy, tell the user and propose which takes to cut.

**Check.** At the storyboard gate, snapshot each QC range in output time and confirm that the face is covered. Add a "Face QC" column to the storyboard table.

## Recording checklist (Hollyland Lark A1 Mini into iPhone)

Tell the user this when the raw voice sounds muddy or unclear:
- Set the mic noise cancellation to off or weak indoors. Medium and strong remove voice detail that EQ cannot bring back.
- Clip the mic on top of clothing, about 15–20 cm below the chin.
- Lower the gain until peaks sit around -6 to -12 dB.
- On iPhone 16 or later, set Camera Audio Mix to Standard and turn off Wind Noise Reduction (Settings > Camera > Record Sound).

## Hard-won technical notes

- **Render loudness:** the renderer lowers the whole mix to keep it under -1 dBTP ("Audio lowered by X dB" in the render log). Loud SFX peaks then pull the voice down (one render dropped 6.3 dB, to -20.7 LUFS). Always put a master bus on the root: `data-fx-chain` with `gain` +1.5 dB, then `truepeak` with a ceiling of -3 dBTP. Check the log for "lowered" after every render.
- **Behind-head words:** skip them when the head fills the top of the frame. The word is hidden behind the hair and cannot be read.
- **Two b-rolls back to back:** keep the first card fully opaque and dissolve the second one in on top. If both fade at once, the face shows through as a double exposure.
- **Speed:** CLI renders use the hardware GPU (Intel UHD 630). Studio renders fell back to software WebGL and took over an hour. Render from the CLI. If a render crawls, check for parallel renders, then consider baking the grade with ffmpeg as a fallback.
- **Keyframes:** any re-encoded source needs `-g 30 -keyint_min 30`. Sparse keyframes cause seek freezes.
- **Zooms and behind-head words:** a camera zoom pushes top-anchored words off-frame. Keep the camera at 1.0–1.04 while they show.
- **SFX levels:** SFX under speech need volume of 0.75 or more to be audible. Measure with `volumedetect` at each cue. For clicks and bells, compare the 5 kHz+ band against a voice-only track.
- **Quiet SFX files:** many stock SFX files sit at -24 to -30 LUFS, so they need gains above 1. The template's files are already set in the sound map in `style.md` (for example camera flash 2.5, click 2.0, mechanical click 3.5, sharp riser 2.5, which needs the master `truepeak`). Skip meme sounds (vine boom, pop) and harsh metallic risers in this style.
- **Live SVG `feTurbulence` grain is slow.** Use the static `assets/tex/grain.png` overlay instead.
- **Desktop app:** before editing a project that was open in the HyperFrames desktop app, run `npx hyperframes catch-up <dir>`.
