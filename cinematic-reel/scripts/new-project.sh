#!/usr/bin/env bash
# Create a new cinematic-reel project from the skill template.
# Usage: bash .claude/skills/cinematic-reel/scripts/new-project.sh <kebab-name> [videos-dir]
set -euo pipefail

NAME="${1:?usage: new-project.sh <kebab-name> [videos-dir]}"
VIDEOS="${2:-videos}"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$VIDEOS/$NAME"

if [ -e "$DEST" ]; then
  echo "error: $DEST already exists" >&2
  exit 1
fi

mkdir -p "$DEST"
cp -R "$SKILL_DIR/template/." "$DEST/"
mkdir -p "$DEST/renders" "$DEST/storyboard" "$DEST/qc"
mv "$DEST/storyboard-template.html" "$DEST/storyboard/index.html"
sed -i '' "s/PROJECT_ID/$NAME/; s/PROJECT_NAME/$NAME/" "$DEST/meta.json"
sed -i '' "s/cinematic-reel-project/$NAME/" "$DEST/package.json"

echo "created $DEST"
echo "next: bash $SKILL_DIR/scripts/audio-qc.sh <clip>, then bash $SKILL_DIR/scripts/prep-source.sh <clip> $DEST"
