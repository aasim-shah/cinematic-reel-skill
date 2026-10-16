# Paper tear transition (`compositions/fx/paper-tear.html`, prefix `pt-`)

**What it is.** An overlay transition across a hard cut. A board-paper sheet (`#dedbd3` × `paper.png`, never kraft) slides down over the outgoing shot and covers the frame at the cut. Then a tear runs down it, with a white fibre core along a seeded jagged edge. The two halves hinge open from the top, like a real tear, and pull away left and right with a lift shadow to reveal the next shot. A typed line ("— CONTINUED —") is printed across the tear line, so the tear splits it.

**When to use it.** Between two chapters or ideas: from a board into a face beat, or from one argument to the next ("lekin…", "ab dekho…"). Use it at most once per reel; it is a strong transition.

**What it needs.** No footage and no matte. Slot about 1.0 s (0.9–1.3 s), placed so `coverAt` (0.44 local) lands exactly on the root hard cut, for example slot start = cut − 0.44.

**How to reuse it.** Copy the file and edit `CONFIG`: the times, `seed` (a different tear shape), `edgeTop`/`edgeBottom` (where the tear runs; keep it near the centre), `jag`/`fibre` (edge roughness), the core widths, the hinge angles, `awayX`, and the two printed lines. Nothing else needs to change.

**Timing rules.**
- The sheet slide (0–0.42) uses `power3.inOut`, which is calm with no slam.
- Hold about 0.06 s of full cover after the cut.
- The tear runs in 0.12 s, then the halves hinge open (`power1.in`) and leave (`power2.in`) by 1.0.
- Both halves must be fully off frame at the slot end.

**SFX.** `whoosh-short` (0.7) as the sheet slides in, and `woosh` (0.85, about 0.6 s) on the rip. No click.

**Pitfalls.**
- The intact sheet is swapped for the halves at `tearAt`. Two clipped halves that abut leave an antialiased hairline, so never show them at rest.
- The left half is on top (z-index 2), so its wider white core shows while the tear runs. If you swap the core widths, swap the z-order as well.
- The halves have `transform-origin` at their own bottom corners (sheet offset −50 px). Keep that if you resize the sheet.
- The paper is in the cinematic palette. Do not make it a torn caption strip; that is a retired paper-reel element.
