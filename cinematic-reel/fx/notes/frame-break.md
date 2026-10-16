# FX: Frame break (`compositions/fx/frame-break.html`, prefix `fb-`)

**What it is.** The footage plays inside a floating vertical reel card (560×996, 38 px corners, a thin film-white border and generic UI: heart, comment, share, more, avatar, "@aapka.channel", a Follow pill, a caption and a red progress bar). The card sits over a dark, blurred, vignetted copy of the room. The speaker's head and arm **break out** of the card: the matte is drawn above the card border and clipped to a region larger than the card (up and to the left). On the key word the card pushes toward the camera until it *is* the frame, ending on the normal full-screen shot. A red Tillana note ("khatre?") writes on.

**When to use it.** On lines about content, reels, being seen or social media, or as a "let me tell you straight" moment that breaks the fourth wall ("Aaj main aapko clear karta hoon…").

**What it needs.** The plate, a matte with the same timing, and a second plate copy for the blurred background. Slot length is 2.5–4 s. The arm or head must reach past the card edges in the chosen `foot` transform.

**How to reuse it.** Copy the file and edit `CONFIG`:
- `card` sets the rect. UI text must stay above y 1420 (subtitle band).
- `foot` (x, y, scale) places the footage inside the card. Keep `x ≤ 0` so the arm's own frame-edge cut lands off-screen.
- `breakClip` is the `inset()` region where the cut-out may leave the card. Never let it extend right of or below the card.
- Also: `handle`, `caption`, `likes`, `likeAt`, `pushAt`, `pushDur`, `note` and `noteBox`.

Then update the three `<video>` tags. The background copy must differ from the card plate in src, start or duration (it is 0.01 s shorter here), or lint flags `duplicate_media_discovery_risk`.

**Timing rules.** The card is on screen from frame 0 and settles from a camera scale of 1.035 (0.8 s, `expo.out`), then floats (y +6→−8, tilt −1.4°→−0.5°, `sine.inOut`). The like fills on a beat with a 0.3 s count roll. The push lasts 0.7 s (`power3.inOut`). The camera goes to `1080/card.w` and the footage relaxes to `card.w/1080` at the card origin, so the net scale ends at exactly 1.0 and the cut to the next full-frame shot is seamless. The UI fades in 0.24 s as the push starts.

**SFX.** One `click-soft` (1.0) on the like, and one `whoosh-short` (0.75) on the push.

**Pitfalls.**
- The matte, the card plate and the push must share one transform (`.fb-foot`), or the cut-out drifts off the plate.
- Do not put a CSS filter on a graded `<video>`. Blur the untimed wrapper (`#fb-bg`) instead.
- A matte with curtain spill at the far left needs the `.fb-fg` clip-path, which here keeps the arm because it only applies above y 900.
- Use generic icons only, with no platform logos.
