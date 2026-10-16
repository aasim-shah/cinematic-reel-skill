#!/usr/bin/env bash
# Measure the voice quality of a clip (raw upload or prepped take).
#   - loudness (LUFS), true peak, near-clip windows
#   - noise level in the quietest second
#   - tone balance: RMS per band (mud 300 Hz, body 1 kHz, clarity 3 kHz, air 10 kHz+)
#   - stereo: dual-mono or not
# Usage: scripts/audio-qc.sh <clip>
# Healthy voice after prep: about -14 LUFS, peak below -1 dB, quiet second below -55 dB,
# and 300 Hz no more than about 11 dB above 3 kHz (the old muddy raw was 15 dB).
set -euo pipefail
IN="$1"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
ffmpeg -v error -y -i "$IN" -vn -map 0:a:0 -c:a pcm_s16le -ar 48000 "$TMP/a.wav"

rms() { ffmpeg -hide_banner -i "$TMP/a.wav" -af "$1,astats=metadata=0:measure_perchannel=none" -f null - 2>&1 | grep "RMS level dB" | awk '{printf "%.1f", $NF}'; }

echo "== format"
ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,channels,bit_rate -of compact "$IN"

echo "== loudness"
ffmpeg -hide_banner -i "$TMP/a.wav" -af ebur128=peak=true -f null - 2>&1 | grep -A20 Summary | grep -E "I:|LRA:|Peak:"
ffmpeg -hide_banner -i "$TMP/a.wav" -af astats=metadata=0:measure_perchannel=none -f null - 2>&1 | grep -E "Peak level dB"
printf "0.1 s windows peaking above -1 dB: "
ffmpeg -hide_banner -i "$TMP/a.wav" -af "asetnsamples=4800,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null - 2>&1 \
  | grep -oE "Peak_level=-?[0-9.]+" | awk -F= '$2 > -1' | wc -l | tr -d ' '

echo "== noise (quietest 1 s window, dB RMS)"
ffmpeg -hide_banner -i "$TMP/a.wav" -af "asetnsamples=48000,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level" -f null - 2>&1 \
  | grep -oE "RMS_level=-?[0-9.inf]+" | cut -d= -f2 | grep -v inf | sort -n | head -1

echo "== tone balance (dB RMS)"
M=$(rms "bandpass=f=300:width_type=o:w=1"); B=$(rms "bandpass=f=1000:width_type=o:w=1")
C=$(rms "bandpass=f=3000:width_type=o:w=1"); A=$(rms "highpass=f=10000")
echo "300 Hz $M | 1 kHz $B | 3 kHz $C | 10 kHz+ $A"
awk -v m="$M" -v c="$C" 'BEGIN{d=m-c; printf "mud vs clarity (300 Hz - 3 kHz): %.1f dB%s\n", d, (d>11?"  -> muddy, needs mud cut + presence boost":"")}'

echo "== stereo"
if ffprobe -v error -select_streams a:0 -show_entries stream=channels -of csv=p=0 "$IN" | grep -q '^2$'; then
  ffmpeg -hide_banner -i "$TMP/a.wav" -af "pan=mono|c0=c0-c1,astats=metadata=0:measure_perchannel=none" -f null - 2>&1 | grep "RMS level dB" | awk '{print "L-R difference RMS: " $NF " (-inf = dual mono)"}'
else
  echo "mono"
fi
