# Cinematic reel: locked style tokens

The approved reference (in the author's workspace) is `videos/style-samples/renders/sample-A-cinematic-final.mp4`, approved 2026-10-16. `template/` is its source project. Do not change these tokens without the user's approval.

## Palette (one accent only)

| Token | Value | Use |
|---|---|---|
| `--ink` | `#050505` | letterbox bars, black frames |
| `--film` | `#efe9df` | all type on video (HUD, titles, subtitles, white hand notes) |
| `--signal` | `#e0301e` | the ONE accent: red circles, rules, string, red hand notes, the last-word colour change |
| board red | `#d8321d` / `#c4301e` | the same red on paper (stamp, string, circles on the board) |
| board felt | `#3a3d40` × `assets/tex/felt.png` | evidence-board background |
| paper | `#dedbd3` / `#ebe9e3` × `assets/tex/paper.png` | clippings, index cards, polaroids |

No other colours: no yellow, no gold, no teal UI, no gradients other than scrims and vignettes.

## Type

| Role | Font | Notes |
|---|---|---|
| Titles, giant behind-head word | Anton (`assets/type/Anton.woff2`) | uppercase; title 150 px, behind-head 452 px, board number 300 px |
| HUD, kickers, tags, timecode | IBM Plex Mono 500 (Google, resolved by HyperFrames) | uppercase, letter-spacing 0.2–0.26em, 26–30 px |
| Subtitles | IBM Plex Sans 500 (`assets/type/IBMPlexSans.woff2`) | 46 px, white, no box; words go from 0.4 to 1.0 opacity as spoken |
| Newspaper mast, headline | Playfair Display 800–900 (Google) | board only |
| Typewriter labels | Special Elite (`assets/type/SpecialElite.woff2`) | case strip, "PREDICTION —" lines, stamps |
| Pen notes | **Kalam 700** (`assets/fonts/Kalam-700.woff2`) | white on video, ink on paper; side remarks, polaroid labels, card footers |
| Display hand | **Tillana 700** (`assets/fonts/Tillana-700.woff2`) | red or white; one-to-three-word reactions ("kitna?", "sirf 3 saal!", "kya sach mein?") |

Kalam and Tillana are the only handwriting fonts (workspace hard rule). They are accents: about one hand note per beat, never the subtitles.

## Colour grade (natural skin; approved after "face colour a bit over")

Apply with `npx hyperframes media-treatment --selector ".take, .take-fg" --grading '<json>' --apply`:

```json
{"preset":null,"intensity":1,"adjust":{"exposure":0.02,"contrast":0.04,"highlights":-0.14,"shadows":0.08,"whites":-0.02,"blacks":-0.02,"temperature":-0.03,"tint":0,"vibrance":0,"saturation":-0.08},"details":{"vignette":0.18,"vignetteMidpoint":0.5,"vignetteRoundness":0,"vignetteFeather":0.8,"grain":0.1,"grainSize":0.14,"grainRoughness":0.6},"effects":{"bloom":0.15,"bloomRadius":22},"colorSpace":"rec709","wheels":{"shadows":{"hue":195,"amount":0.08,"level":0},"midtones":{"hue":198,"amount":0,"level":0},"highlights":{"hue":34,"amount":0,"level":0}},"curves":{"master":[[0,0.015],[0.25,0.245],[0.6,0.605],[0.88,0.875],[1,0.975]],"red":[[0,0],[1,1]],"green":[[0,0],[1,1]],"blue":[[0,0],[1,1]]},"secondaries":[{"enabled":true,"key":{"hue":{"center":325,"range":30,"softness":20},"saturation":{"min":0.15,"max":1,"softness":0.1},"luma":{"min":0.03,"max":0.9,"softness":0.1}},"correction":{"hueShift":6,"saturation":-0.12,"luma":-0.02,"temperature":0,"tint":0}},{"enabled":true,"key":{"hue":{"center":222,"range":22,"softness":16},"saturation":{"min":0.2,"max":1,"softness":0.1},"luma":{"min":0.05,"max":0.95,"softness":0.1}},"correction":{"hueShift":0,"saturation":-0.12,"luma":-0.03,"temperature":0,"tint":0}}]}
```

The skin must look like the raw footage, not orange or crushed. The cinematic feel comes from the letterbox, HUD, grain and the board, not from a heavy grade. Check the result with a three-panel still: a raw ffmpeg frame, the snapshot, and the reference render.

Film grain overlay: `#grain` uses `assets/tex/grain.png` at `mix-blend-mode: overlay; opacity: 0.08`, re-seeded every 1/24 s. Do not go above 0.1.

## Motion

| Move | Values |
|---|---|
| Cold-open rack focus | `#stage` blur 14 px → 0 over 0.55 s, `power2.out` |
| Slow push | `#camera` scale 1.0 → 1.075 over the cold open, `power1.inOut`; title beats 1.12 → 1.165 linear drift |
| Letterbox in | bars from ±960 to ±680 px, 0.6 s, `power4.out` |
| Shutter close (cut to black) | bars to 0, 0.33 s, `power3.in` |
| Shutter reopen | bars 0 → ±680, 0.62 s, `power3.inOut` |
| Title words | each word rises from `yPercent: 108` inside an overflow mask, 0.4 s, `expo.out`, on its spoken word |
| Red circle / box / arrow | SVG stroke-dashoffset draw, 0.18–0.36 s, `power2.out` |
| Hand note | written on left to right with `clipPath: inset(-20% 100% -20% -4%)` → `inset(-20% -4% -20% -4%)`, 0.3–0.6 s, `sine.inOut` |
| Typed HUD label | per-character `tl.set(opacity 1)`, 0.026–0.04 s per character |
| Flash | `#flash` (`#fff6ea`) 0 → 0.88 in 0.05 s, out in 0.42 s (on a name); 0 → 1 in 0.15 s, out in 0.42 s (cut back to face) |
| Behind-head word | Anton 452 px, opacity 0 → 1 and scale 1.14 → 1 over 1.1 s, `expo.out`; red rule `scaleX` 0 → 1 over 0.55 s |
| Board camera | moves in world space only (`#bd-pan` x/y, `#bd-zoom` scale/rotation); push-ins 0.4–0.65 s `power3.inOut`; crash push 1.2 → 5.2 over 0.63 s `power3.in` into a flash |

Never: bounces, `back.out`, shakes, spins, per-word caption pops, sticker pops.

## Sound map (approved levels)

| Cue | File | Volume | When |
|---|---|---|---|
| Typing | `click.mp3` | 2.0 | ONE click when a HUD label or kicker starts typing. Never one per character or word. |
| Tick | `click-soft.mp3` | 1.0 | ONE tick as the red circle lands on the title keyword |
| Letterbox in | `whoosh-short.mp3` | 0.85 | bars slide in |
| Shutter close | `woosh.mp3` | 0.9 | bars close to black |
| Shutter reopen | `whoosh-short.mp3` | 0.7 | bars reopen on the board |
| String draw | `whoosh-short.mp3` | 0.55 | red string draws |
| Flash | `camera-flash.mp3` | 2.5, automation 1 → 1 at 0.3 s → 0 at 0.5 s | flash on a name, flash cut back to face |
| Stamp | `mech-click.mp3` | 3.5 | rubber stamp hits |
| Crash push | `woosh.mp3` | 1.0 | board crash-zoom into the next beat |
| Ending riser | `riser-sharp.mp3` | 2.5 | last ~1 s |

**Click budget:** at most one click-type cue (click, tick, stamp) every ~2 s. The approved 14 s sample has 6 (0.2, 5.86, 7.0, 8.12, 9.94, 12.34 s). 15 clicks in 14 s was rejected as "used too often".

Master bus on the root (already in the template): `gain` +1.5 dB, then `truepeak` −3 dBTP. Voice at −14 LUFS.
