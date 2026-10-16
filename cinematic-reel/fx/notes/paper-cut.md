# FX: Paper cut + doodle boil (`compositions/fx/paper-cut.html`, prefix `pc-`)

**What it is.** The speaker becomes a paper sticker. A ~16 px film-white outline hugs his silhouette, with a soft paper lift shadow, and the room dims slightly. Hand-drawn doodles draw on and then **boil**: a red heart sticker with a white edge, white sparkle lines, a red arrow and a Kalam note ("creativity!"). Every 1/10 s each stroke is re-posed with seeded jitter, like hand animation.

**When to use it.** On words about personality, creativity, "show yourself", personal brand or self-expression. It is a playful accent beat of 2–3 s.

**What it needs.** The plate and a **clean** matte with the same timing. The outline amplifies any faint or stray alpha into solid white. The raw `m3-fg.webm` spilled the curtain on 19 of 75 frames, so the effect uses `assets/fx/paper-cut/m3-fg-clean.webm`, made with `assets/fx/paper-cut/clean_matte.py`. On glitch frames, that script limits alpha in the left strip to a 12 px dilation of the nearest clean frame. It also drops alpha below 48 in that strip on every frame.
- Run: `python3 assets/fx/paper-cut/clean_matte.py <in.webm> <out.webm>` (needs numpy, scipy and ffmpeg with libvpx-vp9). Adjust `zone` to where your spill is.

**How to reuse it.** Copy the file, run the cleaner on your matte, and point `#pc-fg` to it. Re-trace the `.pc-fg` polygon about 0–25 px outside the body on the spill side. Edit `CONFIG`: `outlineStep` (thickness ≈ 2.41 × step), `dim`, `liftShadow`, `note`/`noteBox`, the cue times, and `doodles` (path data in frame px, placed in the free side of the frame), plus `heartDy`.

**The outline.** It is a Minkowski chain of 8 `drop-shadow`s (±a on x, y and both diagonals) on the matte's untimed wrapper. That gives an octagonal dilation of radius 2.41·a with no second video. It is animated through the CSS variable `--pc-a` (0 → 6.6 px in 0.34 s, `power2.out`). Never chain offset shadows in only one direction, because their sum grows out of control.

**Boil helper (lift into the skill).**
- `boil(tl, pathEl, baseD, { seed, fps = 10, amp = 2.5, poses = 3, start, end })` jitters every number in `baseD` by ±amp. It adds one `tl.set(attr.d)` per 1/fps s and cycles `poses` drawings, the way a hand animator loops 2–3 drawings. It is deterministic and seek-safe (seeded `hash01`, no clocks, no `Math.random`). Give stroked paths `pathLength="1"` so a dash draw-on (`strokeDashoffset` 1→0) survives the re-posing. Paths that must move together (the heart's edge, fill and line) share a seed.
- `boilEl(tl, el, { seed, fps, amp = 1.5, rot = 0.6, poses, start, end })` boils any element (x, y and rotation jitter). Use it on a wrapper whose transform nothing else animates (here, the note's wrapper).

**Timing rules.** The outline grows at 0.04. The doodles start on the keyword: the heart line draws over 0.3 s, then the white edge and red fill settle in, then the arrow and the note (written on left to right in 0.42 s). Second sparkles come on the next stressed word ("show"). Everything boils from its own start until the slot ends. Keep it to one note and about 3 doodle groups, with no pops or bounces.

**SFX.** One `whoosh-short` (0.6) as the sticker cuts out, and one `click-soft` (1.0) as the heart lands.

**Pitfalls.**
- Any clip-path edge that touches alpha gets an outline: on frames where the head leans left, a short straight segment can show at x 360.
- 9 drop-shadows on a full-frame video are fine on the GPU, but do not stack two outlined mattes.
- Keep doodles out of the HUD band (the sparkles nearly hit y 160 before `heartDy` was added).
