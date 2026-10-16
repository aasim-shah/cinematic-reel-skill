# Headline wall (`compositions/fx/headline-wall.html`, prefix `hw-`)

**What it is.** A face effect. The room behind the speaker is replaced by a felt wall pinned with paper headline clippings (Playfair, fictional mastheads) and search-bar bubbles (generic UI with a magnifier icon and a red caret). The person matte keeps him in front, and a darkened, blurred, offset matte copy casts a soft shadow on the wall. On the spoken words, one clipping gets a red double strike and its copy recedes; another gets a red hand circle. The wall drifts slowly (scale 1.035 → 1.0).

**When to use it.** On lines about public fear, hype or a debate ("AI se competition nahi karni", "log kehte hain…"), where the speaker reframes the headline: strike the wrong frame, circle the right one.

**What it needs.** A person matte (VP9 alpha) with the same timing as the plate clips. Slot 3–6 s (built for 4.9 s, with two kept ranges). It needs one plate `<video>`, one shadow copy and one matte `<video>` per kept range. Copy the grade from `build/grading.attr` into every one of them.

**How to reuse it.** Copy the file. Edit the MEDIA blocks (src, data-start, data-duration, data-media-start for each range; give the shadow copy +1 frame of media-start to avoid duplicate-media detection). Edit `CONFIG`: the copy, `strikeAt`, `circleAt` and the drift. Move clippings via their inline styles so the key ones sit in the free wall area beside the head (here x 0–360 left and x 860–1080 right, y 180–950).

**Timing rules.**
- The strike draws on the rejected word: two strokes about 0.25 s apart, then the copy dims to 0.55.
- The circle draws on the verb of the reframe (0.36 s, `power2.out`).
- The wall is present from frame 0. Never pop clippings in.

**SFX.** `whoosh-short` (0.55) on the first strike stroke, and `click-soft` (1.0) when the circle lands.

**Pitfalls.**
- Check each matte range for curtain pickup. Here range A was clean, so it is unclipped (the default polygon would cut the raised hand), and range B picked up the curtain, so `#hw-fg-b`/`#hw-sh-b` get the curtain polygon.
- The wall layer fades out at y 1560–1700 so the real table stays in front.
- Pins and bubbles must not sit on the mastheads.
- Filler text that is cut by the head reads as an error, so use body-line texture for fillers.
- Lint warns about duplicate media: the in-comp plate equals the root take clip. This is expected.
