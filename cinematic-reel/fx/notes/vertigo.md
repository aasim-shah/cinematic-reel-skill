# Vertigo / dolly zoom (`fx/vertigo.html`, prefix `vg-`)

**What it is.** The speaker cut-out holds its size while the room behind changes its field of view and stretches away (room scale 1.62 → 1.18, `power2.inOut`, then a slow drift). At the fastest moment, the room darkens and picks up a radial zoom blur (two plate copies pushed outward). A giant red Anton word lands behind the head, with a red rule and a typed mono tag. It ends calm.

**When to use it.** One shock line or absolute claim: "100%", "sab kuch", "never". Peak the move on that word.

**Needs.**
- The matte webm for the slot.
- A **still clean plate**: the room with the speaker painted out. Build it with `assets/fx/vertigo/make_clean_plate.py` (numpy + Pillow; usage is in its docstring) from one plate frame and one matte alpha frame.
- No plate video. A tripod room reads as live behind the moving cut-out.
- Slot length 2.5–4 s.

**Why a clean plate.** If the room layer still contains the speaker, a second, differently sized copy of him peeks out around the cut-out. The brief's "matte 1.14 over plate 1.12 → 1.0" trick also forces the head to fill the top of the frame, which leaves no room for the word. The clean plate removes both problems.

**Reuse.** Copy the file and build a clean plate for the new take. Edit `CONFIG`:
- `word`, `wordSize` (Anton "100%" is 2.38 em wide), `tag`
- `subjectY`: shifts the cut-out down to free the top third for the word
- `tableY`: the table edge in the source frame
- `focus`, `dolly`, `blur`, `dark`, and the cue times in `t`

Then edit the matte `<video>` attributes and the plate `src`.

**Timing rules.**
- The word lands about 0.06 s before its spoken word (`expo.out`, 1.1 s). The rule follows at +0.16 s and the tag at +0.38 s.
- The dolly's fastest point (the middle of `dolly.dur`) should sit on the word.
- Keep the room scale ≥ `1 + subjectY / tableY`, or the top edge of the plate shows.

**SFX.** `whoosh-short` 0.6 under the darkening and word landing. ONE `click` 2.0 when the tag types.

**Pitfalls.**
- The root CSS puts the curtain clip-path on every `.take-fg`. When the cut-out is shifted, the polygon slices the shoulder, so `#vg-fg` sets `clip-path: none`. Only re-add a polygon, in shifted coordinates, if the matte picks up curtain.
- The room scales about the table line (`tableY`), so the forearms keep resting on the table. A face-centred pivot makes the table slide under the arms, and the torso's straight bottom edge then floats.
- The entry scale (`entry.from`) must match `zoom-through` `CONFIG.next.camTo` when the two are chained.
