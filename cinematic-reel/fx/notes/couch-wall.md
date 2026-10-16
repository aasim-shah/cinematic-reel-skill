# FX: Couch wall (`compositions/fx/couch-wall.html`, prefix `cw-`)

**What it is.** The room behind the speaker is replaced by a lamp-lit felt wall of his own video thumbnails (stills of the take), 6×5 grid, slightly perspective-tilted, drifting in slow parallax. Each tile has a mono tape label ("TAPE 08 · 02:56"); a few carry Anton cover titles ("AI vs JOB", "2029?"). On the money words one or two tiles get a red frame drawn round them and brighten, and a red Kalam note ("salary") writes on with an underline.

**When to use.** Lines about the creator's own work, output, archive or earnings ("kaam karta hai… paise milte hain… salary milti hai"), or "I've made hundreds of these".

**Needs.** Plate + matte webm (matte must stop at the table/desk line, the plate supplies the real table below). 10–13 stills: `ffmpeg -ss <t> -i assets/take.mp4 -frames:v 1 -vf "crop=…,scale=300:534,eq=saturation=0.88:contrast=1.04"` into `assets/fx/couch-wall/thumb-NN.jpg` (mix full, mid and tight crops; skip bad faces). Slot 3–6 s.

**Reuse.** Copy the file, edit `CONFIG` (`imgCount`, `colX`/`rowY` grid, `titles`, `frames` [{at, tile:"col,row"}], `note`, `drift`, `settle`) and the two `<video>` media attributes. Move the `#cw-note` CSS position to sit next to the framed tile. Adjust the `#cw-room` mask (1560→1650 px) to the table line of the new footage.

**Timing rules.** Wall is fully present at local 0 (it can be revealed by a cut or the paper tear); it settles 1.05→1.0 over 1.8 s and drifts the whole slot (`sine.inOut`). Red frame on the word (0.36 s draw); note 0.06 s after the second frame, underline +0.42 s. At most two framed tiles.

**SFX.** One `click-soft` 1.0 on the first red frame; `whoosh-short` 0.55 as the note writes. The transition into it carries its own whoosh.

**Pitfalls.** Tile labels must never land in y 100–170 or 1436–1576: plan `rowY` so label rows fall outside (tile bottom at y 60, 504, 948, 1392). Keep tiles dim (brightness ~0.62) plus the lamp vignette and head shadow, or the busy wall fights the face. Pick a framed tile that stays visible beside the head (outer columns), not one hidden behind it.
