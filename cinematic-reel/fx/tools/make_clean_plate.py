#!/usr/bin/env python3
"""Build a "clean plate" (the room with the speaker painted out) for the vertigo effect.

Why: a dolly-zoom scales the room and the speaker differently. If the room layer still
contains the speaker, a second, differently-sized copy of him peeks out around the
cut-out ("ghost"). A still clean plate removes the ghost completely, so the room can
scale freely. The room is static (tripod shot), so a still reads as live behind the
moving cut-out.

Usage (numpy + Pillow only):
  ffmpeg -ss <plate media-start> -i assets/take.mp4 -frames:v 1 /tmp/frame.png
  ffmpeg -c:v libvpx-vp9 -ss <matte media-start> -i assets/<matte>.webm -frames:v 1 \
         -vf alphaextract /tmp/alpha.png
  python3 make_clean_plate.py /tmp/frame.png /tmp/alpha.png assets/fx/vertigo/clean-plate.jpg

Method: dilate the person mask. Build a wall colour profile per column from clean rows above
the head, then paint masked wall pixels with that profile scaled to each row's brightness
(measured on the clean wall left and right of the head, lerped across). Curtain columns continue downward from the
row above. The table band is filled bottom-up from clean table pixels.
Finally the fill is softened and the whole plate gets a light lens blur (shallow depth
of field), which also hides the paint-out.
"""
import sys
import numpy as np
from PIL import Image, ImageFilter

DILATE = 25                 # px of safety margin around the person (hair edges are soft)
SAMPLE = 9                  # px averaged on the clean side of each run (reduces noise)
WALL_ROWS = (20, 220)      # clean wall rows above the head, used as the wall colour profile
DARKEN_DOWN = 0.9993        # per-row darkening where no clean wall exists (shoulder rows)
TABLE_TOP = 1630            # y where the table starts in the source frame (rows below fill bottom-up)
LENS_BLUR = 3.0             # final background softness (px)


def main(frame_p, alpha_p, out_p):
    img = np.asarray(Image.open(frame_p).convert("RGB")).astype(np.float32)
    a = Image.open(alpha_p).convert("L")
    a = a.filter(ImageFilter.MaxFilter(DILATE * 2 + 1))
    mask = np.asarray(a) > 6
    h, w, _ = img.shape
    out = img.copy()

    # 1. Wall model: the column colour profile of clean wall rows above the head.
    top = ~mask[WALL_ROWS[0]:WALL_ROWS[1]]
    rows = img[WALL_ROWS[0]:WALL_ROWS[1]]
    prof = np.array([rows[top[:, x], x].mean(axis=0) if top[:, x].any() else rows[:, x].mean(axis=0)
                     for x in range(w)])
    # curtain edge: first column from the left whose profile is no longer teal (blue > red)
    edge = next(x for x in range(w) if prof[x, 0] > prof[x, 2] + 6)
    lum = lambda c: float(c.mean()) + 1e-3

    # 2. Rows above the table: wall = profile x per-row brightness (from the clean pixels right
    #    of the head); curtain columns and rows with no clean wall copy the row above.
    ratio_l = ratio_r = 1.0
    for y in range(0, TABLE_TOP):
        row = mask[y]
        if not row.any():
            continue
        wall = ~row
        wall[:edge + 12] = False  # ignore the curtain and its dark edge
        xs = np.where(wall)[0]
        runs = np.where(row[edge:])[0] + edge
        if len(runs):
            lo, hi = runs[0], runs[-1]
            left_xs, right_xs = xs[xs < lo][-SAMPLE * 4:], xs[xs > hi][:SAMPLE * 4]
            if len(right_xs) >= SAMPLE:
                ratio_r = lum(img[y, right_xs].mean(axis=0)) / lum(prof[right_xs].mean(axis=0))
            if len(left_xs) >= SAMPLE:
                ratio_l = lum(img[y, left_xs].mean(axis=0)) / lum(prof[left_xs].mean(axis=0))
            if len(right_xs) < SAMPLE and len(left_xs) < SAMPLE:
                ratio_l *= DARKEN_DOWN; ratio_r *= DARKEN_DOWN  # no clean wall: drift darker toward the table
            span = max(hi - lo, 1)
            for x in range(lo, hi + 1):
                if row[x]:
                    t = (x - lo) / span
                    out[y, x] = prof[x] * (ratio_l * (1 - t) + ratio_r * t)
        for x in np.where(row[:edge])[0]:
            if y > 0:
                out[y, x] = out[y - 1, x]

    # 3. Table band: copy the clean table row below, bottom-up.
    for y in range(h - 1, TABLE_TOP - 1, -1):
        row = mask[y]
        if row.any() and y < h - 1:
            out[y, row] = out[y + 1, row]

    res = Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))
    soft = res.filter(ImageFilter.GaussianBlur(14))
    m = Image.fromarray((mask * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(10))
    res = Image.composite(soft, res, m)
    res = res.filter(ImageFilter.GaussianBlur(LENS_BLUR))
    res.save(out_p, quality=92)


if __name__ == "__main__":
    main(*sys.argv[1:4])
