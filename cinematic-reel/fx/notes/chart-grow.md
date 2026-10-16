# Chart grow (`fx/chart-grow.html`, prefix `cg-`)

**What it is.** A documentary line chart drawn on the wall behind the speaker. The room dims. A hairline grid with mono year labels wipes in from the left. A red line then climbs to a glowing end dot with a ring, a slow pulse and an ink pill ("2029 ↗"). The matte keeps the head in front. Optional exit: the camera pushes into the end dot (built to hand over to `zoom-through`).

**When to use it.** Lines about growth, a forecast or a scale: "all jobs will be replaced", "it doubles every year", "by 2030…". Land the end dot on the key word.

**Needs.** A plate (`take.mp4`) and a matching matte (`.take-fg`) with the same timing. The slot should be 2.2–3.5 s; the draw needs at least 0.8 s. The speaker should leave some wall free on one side of the head (here, the right strip x ≈ 940–1080).

**Reuse.** Copy the file and give it a new `data-composition-id` and id prefix. Edit `CONFIG`: `years`, `values`, `yLabel`, `tag`, `pill`, `pillPos`, `plot`, and the cue times in `t`. Then edit the two `<video>` media attributes (src, `data-media-start`, `data-duration`). Set `exitPush: false` if no zoom-through follows.

**Timing rules.** Start the draw on the first word of the claim (`drawStart`) and land it on the key word (`land`). The pill follows 0.03 s later. Hold at least 0.4 s before `pushStart`. The push lasts from `pushStart` to the slot end (0.4 s, `power3.in`) and ends at the hard cut.

**Layout rules.** Put the steep climb in the LAST segment, inside the free wall beside the head. The middle of the line hides behind the head by design. Keep the year labels above the hair line (top at `yTop − 62`) and below the HUD band (y 170). The pill sits in the foreground layer, so it may graze the hair and stays readable.

**SFX.** `whoosh-short` 0.6 when the line starts. `click-soft` 1.0 on the landing (one click).

**Pitfalls.**
- The wall is cream, so film-white hairlines vanish without `#cg-dim`. Keep the dim on and masked off below the shoulders.
- The dim reveals the matte's light hair fringe. Do not push the dim darker than about 0.85.
- The end-dot position (the last point) must equal `zoom-through` `CONFIG.from` when the two are chained.
- Flex `gap` on the tag: the typed characters sit in one inner span, otherwise the gap spaces every letter apart.
