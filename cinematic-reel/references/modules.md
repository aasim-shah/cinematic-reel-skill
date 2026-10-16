# Cinematic reel: beat modules and how to adapt the template

`template/index.html` is the approved 14 s sample, working as-is. Each beat below is a block in that file, marked by a `// ---------- BEAT n` comment in the script and by element ids in the markup. To build a new video, keep the modules and change only the copy, the times and the board contents. To make a longer video, repeat modules as described in "Scaling".

## Global layers (keep as-is)

Stack order inside `#root`, bottom to top:

1. `#stage` > `#camera`: the take clips (`.take`), then `#dim`, `#bt`, `#bt-rule` (behind-head layer), then the matte clips (`.take-fg`), then `#bt-tag`. `#scrim-top` and `#scrim-bot` sit in `#stage` above `#camera`.
2. Hand notes that sit on the face shots (`#hn-hook`, `#hn-end`, and so on).
3. Board sub-composition(s) (`data-composition-src="compositions/board.html"`).
4. `#bars` (letterbox and shutter).
5. `#ttl` (chapter title, which includes its own hand note and arrow).
6. HUD: `#lbl` (typed case label, two stacked lines `#lbl-a`/`#lbl-b`) and `#tc` (running timecode).
7. `#subs`, `#flash`, `#grain`.

Data at the top of the script:

- `SEGMENTS`: `[srcStart, srcEnd, outStart]` per kept range. It must match the take clips' `data-media-start`, `data-duration` and `data-start`.
- `SUBS`: `[start, end, [[word, t], ...]]` in output seconds. One group is one subtitle line of about 2–7 words. Build it from the transcript.
- `typeable(...)` calls: the HUD label texts (`FILE 01 / <TOPIC>`, `EXHIBIT A / <SOURCE>`), the title kicker and the behind-head tag.
- `HIDE`: windows where subtitles are hidden (chapter title on screen, shutter to black).

Sample-specific parts to replace in every new project:

- `#aud-aaj` / `assets/lcut-aaj.wav`: an L-cut from the sample, where the audio was taken from a separate file so the lint rule `video_audio_double_source` does not fire. Delete it, or make your own L-cuts the same way.
- All the copy (Elon Musk, 2029, `kitna?`, and so on).
- The `#fg-4` clip-path polygon, which is tuned to the sample's curtain.

## Module 1: cold open (face)

What it does: the first frame starts blurred and racks into focus. The camera pushes in slowly. The HUD types `FILE 01 / <TOPIC>` (one click), the timecode runs, and documentary subtitles light word by word. One white Kalam note with a drawn arrow points at the speaker on a key phrase (`#hn-hook`, written on at the phrase, faded out 0.25 s before the next beat).

Adapt: the label text, the push length, and the note text. Keep the note to 2 short lines, place it on the side of the frame away from the face, and keep it clear of the face box.

## Module 2: chapter title (face, letterbox)

What it does: the letterbox bars slide in (whoosh-short). The camera drifts. The mono kicker types (`#ttl-kick`). A two-line Anton title rises word by word on the spoken words (`.ttl-line` > `.m` > `.w`). A red hand circle draws round the keyword (`#ttl-circle-p`, one soft tick). A red Tillana reaction note writes on next to it, with a small arrow (`#hn-ttl`, `#hn-ttl-arrow`). Subtitles are hidden while the title shows.

Adapt: the kicker (2–3 words) and the title words. Keep both title lines `nowrap` at 150 px; if a line is wider than 912 px, shrink the font size instead of wrapping. Pick the circled keyword (the emotional word). Place the Tillana note at the end of line 2, clear of the title glyphs.

## Module 3: shutter to the board (face hidden)

What it does: on the last title word, the bars close to full black (woosh). The title rides up to the centre on black and blurs out. The board sub-composition starts under the closed bars. The bars reopen to letterbox height on the board (whoosh-short). The HUD label switches from line A to line B (`EXHIBIT A / <SOURCE>`, one click).

The face is hidden from the moment the bars meet. Use this to start a Face QC cover.

## Module 4: evidence board (full-screen b-roll; the main Face QC cover)

File: `compositions/board.html` (`#bd-root`, world space 2400×3600 inside `#bd-pan`, camera = `#bd-zoom` scale/rotation + `#bd-pan` x/y). Items:

| Item | id | Use |
|---|---|---|
| Case strip | `#bd-case` | Special Elite: `CASE FILE 01 — <TOPIC>` |
| Newspaper clipping | `#bd-clip` (`#bd-mast`, `#bd-head`, `#bd-iv`, `#bd-photo`, `#bd-body`) | the source or person named in the speech; the headline is that name, the deck is the kind of source (INTERVIEW, REPORT, STUDY) with a red hand box |
| Rubber stamp | `#bd-stamp` | `RECEIVED` + a date, or a verdict word; hit on a beat (mech-click) |
| Polaroids | `#bd-p1`, `#bd-p2` | abstract silhouettes (SVG only, no real photos), Kalam labels `exhibit 02 · office` |
| Chart printout | `#bd-chart` | a rising bar chart; the last bar red |
| Index card | `#bd-card` (`#bd-pred`, `#bd-num`, `#bd-num-circle-p`, `#bd-card-foot`, `#bd-card-note`) | the key number or claim: typed line, giant Anton number, red circle, a Kalam footer, a red Tillana note |
| Red string | `#bd-string` | drawn from the source (pin A) to the claim (pin B); the camera rides its tip |

Camera script (board-local time = root time − `T0`): establishing drift → push into the headline on the name (root `#flash` on the name, camera-flash) → stamp → tilt to the deck and box it → pin + red string to the card (the camera rides the tip) → card typed line → circle → hand note → crash push into the number (into the root flash cut).

Adapt: `T0` and every `L(...)` time to the new spoken words. Change the copy on every item to the new story, and remove items you do not need. Keep the felt, lamp, paper textures, shadows, vignette and the world-space camera. One board can cover up to about 6 s. For a longer cover, use two boards (see "Scaling").

## Module 5: flash cut back + behind-head word (face, ending)

What it does: a white flash covers the cut (camera-flash). The bars slide out and the room dims (`#dim`). A giant Anton word or number sits behind the head (`#bt`, between the take and the matte `#fg-*`), and a red rule draws across under it (`#bt-rule`). The HUD fades. The mono tag types (`#bt-tag`, one click) and a white Tillana note writes on (`#hn-end`). On the final word the big word turns signal red with a soft glow. A riser plays into the end.

Adapt: the word (1–4 characters reads best at 452 px; for longer words lower the size until it fits 1080 px) and the tag. You need a matte clip `.take-fg` for every take clip that runs under this beat, with the same timing attributes. Skip the behind-head word if the head fills the top of the frame.

## Scaling to longer videos (30–120 s)

Order the beats as **cold open → (chapter title → board or face beat)×N → behind-head ending**. Rules:

- About one beat every 3–6 s. A 30 s reel is about 7–8 beats; a 60 s reel about 13–15.
- One chapter title per new idea in the script (max one every ~10 s). Each chapter changes the HUD file label (`FILE 01`, `FILE 02`, …).
- One board per hard Face QC range, and at least one board every ~15 s. Give each board a different exhibit letter (`EXHIBIT A`, `B`, `C`) and different item mix (clipping, chart, index card, polaroid wall, document with black redaction bars). Make a copy of `board.html` per board (`board-b.html`, …) and give each one a unique `data-composition-id` and id prefix.
- Between titles and boards, plain face beats are fine: letterbox on or off, slow push, one hand note at most.
- One behind-head word in the middle at most, plus the ending one.
- Hand notes: about one per beat, never two on screen at once.
- Two boards back to back: keep the first fully opaque and cut between them with the shutter or a crash push into the flash. Never cross-fade two boards over the face.

## Face QC cover options in this style (best first)

1. The board (module 4), with at least 0.15 s margin on both sides.
2. The shutter to black with the title on black (module 3), for ranges under ~0.8 s.
3. Cut the range out if it has no needed speech.

Letterbox, behind-head words, hand notes and zooms never hide a face: the face stays visible.
