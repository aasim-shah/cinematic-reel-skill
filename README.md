# Cinematic Reel: a Claude Code skill

Turn one raw vertical talking-head clip into a premium investigative-documentary reel with [Claude Code](https://claude.com/claude-code) and [HyperFrames](https://hyperframes.heygen.com).

The skill gives every reel the same look: a natural-skin grade, 2.39 letterbox moments, a typed `FILE 01` case-file HUD with running timecode, documentary subtitles, chapter titles with a red hand circle, a full-screen evidence board, a giant word behind the speaker's head, and Kalam/Tillana handwritten notes. It uses one accent colour, signal red.

Landing page and install guide: https://aasim-shah.github.io/cinematic-reel-skill/

## What it does

- **Voice upgrade (Audio QC):** measures the raw voice for mud, hiss, clipping, dull tone and a silent channel. Then it applies a voice chain: light denoise, EQ (less mud at 250 Hz, more clarity at 3.5 kHz and air at 9 kHz), de-esser, compression and −14 LUFS. For unusual problems it builds a custom chain and lets you A/B the raw, default and custom versions. It reports the numbers before and after.
- **Retake removal:** people repeat a line until it lands. Claude rebuilds the script from the transcript and keeps the last clean take of each line. False starts, restarts, fillers ("umm") and abandoned lines are cut.
- **Silence removal:** dead air and long pauses go. Each cut starts just before the first word and ends where the silence begins, with 20–40 ms audio ramps so no cut clicks.
- **Face QC:** every frame is checked for closed eyes, looking away, odd expressions and jump cuts. A full-screen evidence board covers each bad moment while the voice keeps playing.
- **Documentary look:** a natural-skin grade, 2.39 letterbox moments, film grain, a typed `FILE 01` HUD with running timecode, word-by-word subtitles, chapter titles with a red hand circle, and a giant word behind the speaker's head (AI person matte).
- **12 creative effects**, 3–6 per reel, each on a good face moment that matches its line. All twelve play as looping demos on the [landing page](https://aasim-shah.github.io/cinematic-reel-skill/#effects):

  | Effect | Used when the line is about… |
  |---|---|
  | Cover story | the hook or the theme ("everybody is worried") |
  | Frame break | content, reels, "you watching this" |
  | Chart grow | a trend or a number with a direction |
  | Vertigo | one shock claim (once per reel) |
  | Couch wall | your own work, history or routine |
  | Phone mockup | posting, a profile, an app, a personal brand |
  | Paper cut + doodle boil | creativity or personality |
  | Orbit | a list of 2–4 questions or options |
  | Headline wall | public fear, news, "what people say" |
  | Pull-back reveal | a detail that widens to the big picture (also hides a bad take) |
  | Zoom-through cut | a transition joining two effects |
  | Paper tear | a transition between chapters |

- **Sound design:** a short whoosh as the letterbox slides in, a woosh on the shutter to black, a camera flash on names and flash cuts, one typing click per label, a soft tick when the red circle lands, a rubber-stamp hit and a sharp riser into the end. At most one click-type sound every 2 s. A master bus (+1.5 dB, then a −3 dBTP true-peak limiter) keeps the sound effects from pushing the voice down.
- **Storyboard gate:** Claude snapshots every beat and every hidden face moment, then waits for your approval before it renders.

## Requirements

- Claude Code (CLI, desktop app or VS Code extension)
- Node.js 18+ (HyperFrames runs through `npx hyperframes`)
- ffmpeg (`brew install ffmpeg`)
- macOS for source prep: `prep-source.sh` uses Apple's `avconvert` to convert iPhone HDR (HLG) footage. On other systems, give it a clip that is already SDR.
- The HyperFrames skills (`/hyperframes`, `/hyperframes-core`, `/media-use`). Install them from the HyperFrames docs.
- Optional: an ElevenLabs account for fast transcription of clips over about 40 s.

## Install

```bash
git clone https://github.com/aasim-shah/cinematic-reel-skill.git
mkdir -p ~/.claude/skills
cp -R cinematic-reel-skill/cinematic-reel ~/.claude/skills/
```

To install it for one project only, copy the folder into that project's `.claude/skills/` instead. You can also download [`docs/cinematic-reel-skill.zip`](docs/cinematic-reel-skill.zip) and unzip it into either skills folder.

Start Claude Code and type `/cinematic-reel` to check that it loaded.

## Use

Put your raw clip in the project folder and mention it:

```
@my-clip.mov edit this into a cinematic reel
```

Other prompts that work:

```
/cinematic-reel @take-02.mov, the message is "AI won't take your job, people using AI will"
@raw.mov there are retakes and mistakes, cut them and hide bad faces with b-roll
make the storyboard for @interview.mp4 but don't render yet
```

Claude stops at the storyboard. Reply "looks good, render it" or ask for changes. The result is `videos/<name>/renders/<name>-final.mp4` at 1080×1920, 30 fps, about −14 LUFS.

## What's inside

| Path | What |
|---|---|
| `cinematic-reel/SKILL.md` | the workflow Claude follows |
| `cinematic-reel/references/` | locked style tokens, beat modules, effects catalog, Audio and Face QC rules |
| `cinematic-reel/template/` | the approved 14 s sample project: main timeline, evidence board, fonts, textures, SFX, storyboard page |
| `cinematic-reel/fx/` | the 12 effect sub-compositions, notes and matte tools |
| `cinematic-reel/scripts/` | new project, audio QC, source prep |
| `docs/` | the landing page (GitHub Pages) and the skill zip |

The template does not include the sample's footage (`assets/take.mp4`, the matte and an L-cut WAV). Each new project gets its own from the prep, matte and cut steps.

## Credits

Fonts are under the [SIL Open Font License 1.1](https://openfontlicense.org): Anton, IBM Plex Sans, Special Elite, Kalam and Tillana. Video engine: HyperFrames by HeyGen.
