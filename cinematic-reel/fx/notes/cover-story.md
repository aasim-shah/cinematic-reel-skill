# FX: Cover story (`compositions/fx/cover-story.html`, prefix `cv-`)

**What it is.** The talking-head shot becomes a magazine cover. A giant Anton masthead ("WORRIED") sits *behind* the head (between the plate and the matte), a red rule draws under it, a thin film-white inset border frames the cover, and cover lines build on the spoken words: a typed mono kicker, Anton lines with the keyword in red, a red banner ("REPLACED BY AI?"), an issue line and a small barcode. The footage is lowered 220 px so the head covers only the lower part of the masthead and the word still reads. The gap at the top fades to ink like a cover photo.

**When to use it.** As a hook or chapter opener on a claim about "everybody", a trend, or a headline-worthy fear ("everybody is worried…", "the biggest lie about…"). It works best in the first 3–4 s.

**What it needs.** The plate (`take.mp4`) and a matte (VP9 alpha) with the same timing. Slot length is 3–4.5 s. The head should leave about 40% of the masthead visible after the shift; check it with `alpha` bounds (head top y, head left x).

**How to reuse it.** Copy the file and give it a new id or prefix if you use it twice. Edit `CONFIG`: `mast`/`mastSize` (5–8 letters at about 290 px; keep it inside the border), `footY`, `ruleAt`, `kicker`, `line1`/`line2` and `banner` as `[word, localTime, red?]`, `issue`, `price` and `digits`. Update both `<video>` tags (`data-media-start`, `data-duration`). Fit the matte's `.cv-fg` clip-path to the footage's curtain spill.

**Timing rules.** The masthead, border, issue line and barcode are on screen from frame 0, because the hook has to read as a cover at once. The masthead settles from a scale of 1.05 over 1.1 s (`expo.out`). Words rise on their spoken word (`yPercent` 108→0, 0.4 s, `expo.out`). The banner slab wipes in about 0.07 s before its first word. The footage pushes slowly from 1.0 to 1.04 over the slot, with the plate and matte groups always given the same transform.

**SFX.** One `click` (2.0) when the kicker types, and one `whoosh-short` (0.8) on the banner wipe.

**Pitfalls.**
- If the head fills the top of the frame, raise `footY`. Without that, the masthead is unreadable.
- The matte can pick up the curtain on single frames. A clip-path that stops at the head's left edge (x≈410 above y 900 here) hides this.
- The root subtitle scrim (`#sub-scrim`, y 1240→1920) dims the bottom furniture while subtitles show, so keep the issue line and barcode high-contrast.
- Keep text out of the HUD band (y 100–170) and the subtitle band (y 1436–1576).
