#!/usr/bin/env bash
# Prepare a raw phone clip for a paper-reel project.
#   - iPhone HLG/Dolby Vision HDR -> SDR Rec.709 (macOS avconvert does the tonemap)
#   - 1080x1920 vertical, 30 fps, keyframe every second (seek-safe for HyperFrames)
#   - voice cleanup (tuned for Hollyland Lark A1 Mini into iPhone): high-pass 80 Hz, light FFT denoise,
#     cut mud at 250 Hz, presence boost at 3.5 kHz, air shelf at 9 kHz, de-esser, gentle compression,
#     loudnorm -14 LUFS. A strong denoise (afftdn nf=-25) dulled the voice, so keep it light.
# Usage: scripts/prep-source.sh <input.mov> <project-dir>
#        VOICE_AF="<ffmpeg -af chain>" scripts/prep-source.sh ...   (per-clip voice chain from Audio QC)
# Output: <project-dir>/assets/take.mp4
set -euo pipefail
IN="$1"; PROJ="$2"
mkdir -p "$PROJ/assets"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

TRANSFER=$(ffprobe -v error -select_streams v:0 -show_entries stream=color_transfer -of default=nw=1:nk=1 "$IN" | head -1 || true)
SRC="$IN"
if [[ "$TRANSFER" == arib-std-b67* || "$TRANSFER" == smpte2084* ]]; then
  echo "HDR source ($TRANSFER): tonemapping to SDR with avconvert"
  avconvert --source "$IN" --output "$TMP/sdr.mov" --preset PresetHighestQuality --replace >/dev/null
  SRC="$TMP/sdr.mov"
fi

DEFAULT_AF="highpass=f=80,afftdn=nf=-50:nr=6,equalizer=f=250:t=q:w=1.1:g=-3.5,equalizer=f=3500:t=q:w=1.2:g=3,highshelf=f=9000:g=2.5,deesser=i=0.4,acompressor=threshold=-20dB:ratio=3:attack=5:release=80:makeup=1,loudnorm=I=-14:TP=-1.5:LRA=11"
VOICE_AF="${VOICE_AF:-$DEFAULT_AF}"

ffmpeg -y -v error -i "$SRC" \
  -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30,format=yuv420p" \
  -c:v libx264 -crf 16 -preset medium -g 30 -keyint_min 30 -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
  -af "$VOICE_AF" \
  -c:a aac -b:a 192k -ar 48000 -movflags +faststart "$PROJ/assets/take.mp4"

ffprobe -v error -show_entries stream=width,height,r_frame_rate,color_transfer:format=duration -of compact "$PROJ/assets/take.mp4"
