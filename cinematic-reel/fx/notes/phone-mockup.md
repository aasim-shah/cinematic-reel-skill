# FX: Phone mockup (`compositions/fx/phone-mockup.html`, prefix `ph-`)

**What it is.** A phone glides in from the frame edge and floats beside the speaker's head, tilted in 3D (rotY 16°, roll −4°), with a soft drop shadow and screen glare. The screen is a generic creator profile in our palette: avatar (a face still) with a red story ring, "@aapka.brand", stats (posts / followers / views), an Anton "PERSONAL BRAND" header, bio, a red "+ NEW POST" button and a 3-column post grid. On the key word the button presses (scale 0.94 + ripple), a new post fills the dashed "+" slot with a red NEW chip, and the follower count ticks up (in red, then back to white).

**When to use.** Lines about posting, starting a channel, building a brand, apps or online presence ("personal brand par kaam start karna hai").

**Needs.** Plate + matte webm. A free side of frame ~380 px wide beside the head (here the curtain on the left). Stills in `assets/fx/phone-mockup/` (`avatar.jpg` 200×200 face crop, `post-NN.jpg` 240×310). Slot 2.5–4 s.

**Reuse.** Copy the file, edit `CONFIG` (handle, name, bio, button, stats [from/to], post images, `underlineAt`, `pressAt`, `tilt`, `scale`) and the two `<video>` media attributes. Move `#ph-pos` left/top to the free side; for a right-side phone mirror `tilt.rotY` and the entrance `x` sign.

**Layering.** The phone sits **behind** the matte, so the head and shoulder overlap its inner edge (depth) and it can never cover the face. Keep the stats column clear of the head silhouette.

**Timing rules.** Glide in 0.8 s `power3.out` from the first frame (good on a hard cut). Red underline under the name on the brand word (0.4 s). Press on the action word; ripple 0.5 s; new post +0.18 s; count tick 0.9 s `power2.out`. One float yoyo across the slot (±9 px).

**SFX.** `whoosh-short` 0.75 on the glide-in; one `click` 2.0 on the button press.

**Pitfalls.** No real app logos, names or icons. `fromTo` tweens that start late default to immediate render: use `immediateRender:false` for anything that must stay hidden until its cue (the ripple). Dim behind the phone must fade out before y 1080 (matte strip). Here `m2-fg.webm` is 3.266 s for a 3.28 s slot: check that the last frame still has the cut-out.
