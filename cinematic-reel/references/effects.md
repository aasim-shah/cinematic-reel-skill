# Effects library (12 creative effects)

Twelve reusable effects in the cinematic-reel style, each a HyperFrames sub-composition in `fx/<name>.html`. Each file has a commented `CONFIG` block at the top of its script, and commented media attributes. Detailed notes, timing rules and pitfalls are in `fx/notes/<name>.md`; read the note before using an effect. In the author's workspace, a working demo of all twelve is `videos/fx-showcase/` (render: `videos/fx-showcase/renders/fx-showcase-final.mp4`).

Most effects work **with** the speaker. Using the person matte, they put graphics behind or around a GOOD face moment. They are not b-roll: they never hide a bad face, except Pull-back reveal and the transitions. Face QC still uses the evidence board (module 4) for hard ranges.

## Catalog

| Effect | File | Kind | Needs a matte | Slot | Use it when the line… |
|---|---|---|---|---|---|
| Cover story | `fx/cover-story.html` | face, hook | yes | 3–4 s | opens the reel or names the theme ("everybody is worried") |
| Frame break | `fx/frame-break.html` | face | yes | 2.5–3.5 s | is about content, reels or "you watching this"; the speaker breaks out of a reel card |
| Chart grow | `fx/chart-grow.html` | face | yes | 2–3 s | states a trend or number with a direction ("all jobs by 2029") |
| Vertigo | `fx/vertigo.html` | face | yes + clean plate | 2.5–4 s | is ONE shock claim ("100%", "never"); use once per reel |
| Couch wall | `fx/couch-wall.html` | face | yes + stills | 3–5 s | is about his own work, history, or "kaam / salary" routine |
| Phone mockup | `fx/phone-mockup.html` | face | yes + stills | 2.5–4 s | is about posting, a profile, an app or a personal brand |
| Paper cut + doodle boil | `fx/paper-cut.html` | face | yes (clean it) | 2–3 s | is about creativity, personality or "be yourself" |
| Orbit | `fx/orbit.html` | face | yes | 2.5–3 s | lists 2–4 questions or options ("kaun sa kaam, kaise, kis level") |
| Headline wall | `fx/headline-wall.html` | face | yes | 3–5 s | is about public fear, news or "what people say" |
| Pull-back reveal | `fx/pull-back.html` | b-roll (hides the face) | no | 3–4 s | starts from one detail and widens to the big picture; also a Face QC cover |
| Zoom-through cut | `fx/zoom-through.html` | transition overlay | no (uses stills) | 0.8–1 s | joins two face effects; the camera flies through a red ring |
| Paper tear | `fx/paper-tear.html` | transition overlay | no | about 1 s | changes chapter between a board and a face beat |

Budget per reel: at most one effect every about 6–8 s, and never two face effects back to back without a plain face or board beat between them, except a zoom-through pair. Use vertigo, cover story and paper tear at most once each. Fewer, well-timed effects look premium; a parade looks like a template.

## How to use an effect in a project

1. Copy `fx/<name>.html` to `compositions/fx/<name>-<n>.html`. Give each instance its own `data-composition-id`, element id prefix and timeline key, if one reel uses an effect twice.
2. Mount it in `index.html` as a host: `<div id="<slot>" data-composition-id="<slot>" data-composition-src="compositions/fx/<file>" data-start="…" data-duration="…" data-track-index="…">`. Put transition overlays later in the DOM than the scenes they cover.
3. Edit the media attributes inside the file. The muted plate `<video src="assets/take.mp4" data-start="0" data-media-start="<src second of the slot start>">` and the matte `<video src="assets/<matte>.webm" data-media-start="…">` must be in sync with the root take clip that plays the voice. Copy the project's grade into `data-color-grading` on each.
4. Edit `CONFIG`: texts, local cue times (local = root − slot start), positions.
5. Make the matte for the slot's source range: `npx hyperframes remove-background <subclip> -o assets/<name>-fg.webm --quality best`. It takes about 0.6 s per frame on an Intel Mac. Cut the subclip with `-g 30 -keyint_min 30`.
6. Add the SFX cues from the note to the root, within the click budget in `style.md`.
7. Lint, then snapshot each effect at 3–5 times. Check the layering (head in front), outline or matte spill, and that the HUD band (y 100–170) and subtitle band (y 1436–1576) are clear.

## Integration rules (learned while building the showcase)

- **No global `.take-fg { clip-path }` rule in the root.** Root CSS leaks into sub-compositions, and it clipped the mattes inside the effects. Put the curtain clip on the specific root matte clips by id, and let each effect clip its own matte.
- **Root letterbox bars must be parked.** If a project has no `BARS` states, the 960 px bars cover the whole frame and every snapshot is black. Always give the bars an initial off-frame state.
- **Subtitle groups must be timed in output order.** When source ranges are re-ordered, sort the groups by output start before computing each end. Clamp every end to (next start − 0.03 s), or two lines draw on top of each other.
- **Subtitle scrim:** over effects and boards, use a soft band that fades in and out at both edges (about y 1240–1760). A scrim that runs to the frame bottom darkens cover-story borders and other bottom details.
- **Dim layers under a matte must fade out before y 1080.** Otherwise the matte's clipped lower-left strip shows as a bright box.
- **Matte spill (curtain, background):** check zoomed frames. Fix with a polygon `clip-path` on the matte, or clean the alpha with `fx/tools/clean_matte.py` (needed for paper cut, where the white outline amplifies every speck).
- **Vertigo needs a clean plate:** run `fx/tools/make_clean_plate.py` (numpy + Pillow) on one plate frame and one matte alpha frame. Scaling the live plate instead leaves a ghost copy of the speaker around the cut-out.
- **Duplicate media lint** (`duplicate_media_discovery_risk`): an in-effect muted plate with exactly the same src, start and duration as a root clip triggers it. It is a warning only. Offsetting the duration or media-start by one frame silences it if needed.
- **Late-starting `fromTo` tweens** that must stay hidden before their cue need `immediateRender: false`.

## Doodle boil helper (from `fx/paper-cut.html`)

`boil(tl, pathEl, baseD, { seed, fps = 10, amp = 2.5, poses = 3, start, end })` re-poses every number in an SVG path with a seeded hash, cycling through `poses` poses at `fps`. It is deterministic and seek-safe because it only adds `tl.set` calls. Give paths `pathLength="1"` so a dash draw-on survives the re-posing. `boilEl(tl, el, {...})` does the same for any element, using x/y/rotation jitter on a wrapper. Use it on hand circles, arrows, stars and sticker doodles. Keep `amp` at 2–3 px; more looks shaky.
