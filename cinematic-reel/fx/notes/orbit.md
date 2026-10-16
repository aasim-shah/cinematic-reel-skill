# FX: Orbit (`compositions/fx/orbit.html`, prefix `ob-`)

**What it is.** Three paper index cards (typed Special Elite questions, red margin rule) orbit the speaker's head on a tilted 3D ellipse, with a faint dotted orbit trace. Cards pass behind the head (under the matte) and in front of the hair (over the matte). On the key word the orbit slows, a red ring draws round the head (back half hidden by the hair, front half over it) and a red Tillana note ("aap!") writes on with a hand arrow.

**When to use.** A line that lists open questions or choices the viewer must answer ("yeh cheezein aap decide karoge", "kaun sa, kaise, kitna?"). The key word is the person the questions land on ("aap", "you").

**Needs.** Plate `take.mp4` + a matte webm of the same range (`.ob-fg`, clipped by the standard curtain polygon). Headroom above the head (top of head ≥ ~240 px). Slot 2.4–3.5 s.

**Reuse.** Copy the file, edit `CONFIG` (cards, orbit `center`/`radius`/`tilt` measured from the matte, `orbitPeriod`, `slowAt`/`slowEnd`, `keyAt`, `note`, `settleCard`/`settleAngle`) and the two `<video>` media attributes (`data-media-start`, `data-duration`, matte `src`). Measure head extents per row from one matte frame (alpha > 128) and keep `center.x ± radius.x ± half a card` inside 0–1080.

**How it works.** Each card exists twice (back layer under the matte, front layer over it). One `ease:"none"` driver calls `pose(t)`, a pure function of local time: angle → ellipse point → scale/yaw/opacity. The copy on the visible side gets opacity, so the swap happens at the far left/right of the ellipse, off the head. Angle = integral of a smoothstep speed curve, so the slow-down is seamless and seek-safe.

**Timing rules.** Cruise one orbit per ~2.3 s (never faster). Start slowing ~0.2 s before the key word; reach ~20% speed by +0.2 s after. Ring draws on the word (0.36 s `power2.out`), note 0.06 s later, arrow 0.3 s after that. Use `settleAngle` so a card ends near front centre, readable.

**SFX.** `whoosh-short` 0.6 at slot start (cards sweep in); one `click-soft` 1.0 as the red ring lands. Nothing per card.

**Pitfalls.** Front arc must sit above the eyes (cards cross the forehead/hair, never the eyes): keep `center.y + radius.y` ≈ 80+ px above the eye line. Keep back-arc cards out of the HUD band (y 100–170). Any room dim must be masked out before y 1080, or the matte's lower-left strip shows as a bright box. Cards at the extreme sides overflow the frame if `radius.x` is too big.
