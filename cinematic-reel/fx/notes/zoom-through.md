# Zoom-through cut (`fx/zoom-through.html`, prefix `zt-`)

**What it is.** A transition overlay that straddles a hard cut. It reads as the camera flying through a red ring into the next shot:
1. Shot A pushes into a small object, here the chart's end dot.
2. The overlay grows that dot into a red ring portal (radius `power3.in`; the centre drifts toward shot B's face, `power2.in`). Inside the ring, shot B is already visible and moving toward us (a still of its first frame). Outside the ring, shot A sinks into ink.
3. At the cut, the live shot B takes over under the hole. The ring keeps growing past the frame edges, and shot B finishes its own entry push. It is one continuous forward move, with no flash.

**When to use it.** Between two related beats, when one idea leads into the next (a statistic into a reaction, a chart into its consequence). It works best when shot A has a small round focal object (a dot, a pin, a lens, a stamp).

**Needs.**
- Shot A must end with a push into the object (see `chart-grow` `exitPush`).
- Shot B must start with an entry push (see `vertigo` `entry`).
- Two still images that rebuild shot B's first frame: its room and its cut-out frame 0 (`ffmpeg -c:v libvpx-vp9 -i <matte>.webm -frames:v 1 -pix_fmt rgba subject-f0.png`).
- The slot is about 0.9 s, with the cut at about 0.4 s.

**Reuse.** Copy the file. Edit `CONFIG`:
- `from`: shot A's object centre and radius
- `to`: shot B's focus
- `cut`, `rEnd` (larger than the farthest frame corner from the path), `ringDur`, `ringWidth`, `inkOpacity`
- `next`: shot B's first-frame transforms. These must equal shot B's CONFIG.

Then swap the two preview `<img>` sources.

**Timing rules.** The ring grows over 0.8 s and leaves the frame by then. The cut sits at 40–50 % of the slot. Shot A's ink veil should reach `inkOpacity` at the cut, so the outside does not pop.

**SFX.** One `woosh` 1.0 at the slot start (it lasts 1.1 s, which covers the whole move). Nothing else; never a flash.

**Pitfalls.**
- If the preview stills do not match shot B's first frame (scale, shift, pivot), the inside of the hole jumps at the cut.
- The preview is a still for 0.4 s. That is fine inside a small moving ring. Do not make the cut later than about 0.5 s.
- The ring passes over the HUD for about 2 frames. That is acceptable, but keep `from` out of the HUD band.
