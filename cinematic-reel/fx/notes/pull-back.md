# Pull-back reveal (`compositions/fx/pull-back.html`, prefix `pb-`)

**What it is.** A full-screen evidence-board b-roll. It opens macro-tight on one detail (a red rubber stamp "AI" on paper fibres, with a rack focus and a tight lens vignette), holds, then one long decelerating pull-back reveals the memo the stamp sits on ("AI WILL DO ALL THE WORK"), then the whole board: felt, lamp pool, clipping, polaroid, index card, chart printout, pins, red string, vignette. A red underline and a red Tillana note land as the camera settles.

**When to use it.** On a claim or prediction line where the punchline is a short statement ("AI saara kaam karegi", "sab badal jayega"). The macro detail is the line's keyword, and the reveal is the full sentence. It is also a Face QC cover: no footage, so the face is fully hidden.

**What it needs.** No matte and no footage. Slot 3–5 s (built for 3.88 s). Assets: `assets/tex/felt.png`, `paper.png`, `ink-mask.png`, plus Anton, Special Elite, Kalam and Tillana (local) and Playfair Display and IBM Plex Mono (Google).

**How to reuse it.** Copy the file and keep the slot id or rename the `fx-pullback` ids. Edit `CONFIG`: the stamp word, memo lines (two Anton lines of about 11 characters or fewer, never wrapping), note, board copy (fictional mastheads only), camera scales, and cue times. Item positions are world px (2400×3600) in the CSS and are mirrored in `BOX` in the script, so keep both in sync if you move an item.

**Timing rules.**
- Hold the macro until just before the keyword is spoken (`pullAt` about 0.2 s early).
- The pull-back runs about 2.2 s with `power3.out`, in log-space zoom, so the move feels even.
- Land the underline and the note after about 85 % of the move (`pullAt` + 1.0–1.25 s).
- If a transition overlay follows, finish the move about 0.45 s before the slot ends.

**SFX.** One `woosh` (0.9) at `pullAt`. No click: the stamp is already on the paper.

**Pitfalls.**
- Keep strings and threads off the memo face: they cross the macro shot as ugly diagonals.
- Do not read layout sizes (offsetWidth) in the script: fonts are not loaded yet. The stamp centre uses a fixed estimate (`sw`, `sh`).
- Keep board text in the wide view out of y 100–170 (HUD) and y 1436–1576 (subtitles).
- Playfair headlines need about 40 px clear of the clipping edge.
