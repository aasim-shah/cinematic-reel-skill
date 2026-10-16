# Cinematic Reel: a Claude Code skill

Turn one raw vertical talking-head clip into a premium investigative-documentary reel with [Claude Code](https://claude.com/claude-code) and [HyperFrames](https://hyperframes.heygen.com).

The skill gives every reel the same look: a natural-skin grade, 2.39 letterbox moments, a typed `FILE 01` case-file HUD with running timecode, documentary subtitles, chapter titles with a red hand circle, a full-screen evidence board, a giant word behind the speaker's head, and Kalam/Tillana handwritten notes. It uses one accent colour, signal red.

Landing page and install guide: https://aasim-shah.github.io/cinematic-reel-skill/

## What it does

- **Audio QC:** measures the raw voice for mud, hiss, clipping and dull tone, then applies a voice chain (EQ, de-esser, compression, −14 LUFS).
- **Face QC:** reviews every frame for closed eyes, looking away and odd faces. A full-screen evidence board covers each bad moment while the voice keeps playing.
- **Cuts dead air** from a word-level transcript, which also drives the subtitles and beat timing.
- **12 creative effects** (cover story, frame break, chart grow, vertigo, orbit, headline wall, paper tear and more) placed on good face moments.
- **Storyboard gate:** Claude shows every beat and waits for your approval before it renders.

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
