#!/usr/bin/env bash
# install.sh - link (or copy) the humanizer skills into ~/.claude/skills/
#
#   ./install.sh              symlink both skills (updates follow git pull)
#   ./install.sh --copy       install independent copies instead
#   ./install.sh --project    install copies into ./.claude/skills/ of the current dir
#   ./install.sh --force      replace an existing install (backs it up first)

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS=(humanizer structural-humanizer)
MODE=link
TARGET="$HOME/.claude/skills"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)    MODE=copy ;;
    # absolute symlinks break for anyone else who clones the project
    --project) TARGET="$PWD/.claude/skills"; MODE=copy ;;
    --force)   FORCE=1 ;;
    -h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

mkdir -p "$TARGET"
echo "installing into $TARGET (mode: $MODE)"

for skill in "${SKILLS[@]}"; do
  src="$REPO/skills/$skill"
  dst="$TARGET/$skill"

  [[ -d "$src" ]] || { echo "missing $src" >&2; exit 1; }

  if [[ "$MODE" == link && -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "  ok $skill (already linked)"
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ "$FORCE" -eq 0 ]]; then
      echo "  SKIP $skill: already exists at $dst"
      echo "       re-run with --force to replace it (a backup is kept)"
      continue
    fi
    # backups live outside the skills dir so they aren't loaded as duplicate skills
    backup_dir="$(dirname "$TARGET")/skills-backup"
    mkdir -p "$backup_dir"
    backup="$backup_dir/$skill.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "  backed up existing $skill to $backup"
  fi

  if [[ "$MODE" == link ]]; then
    ln -s "$src" "$dst"
    echo "  linked $skill"
  else
    cp -R "$src" "$dst"
    echo "  copied $skill"
  fi
done

chmod +x "$REPO/scripts/copy_scan.py" \
         "$REPO/skills/structural-humanizer/scripts/structural_scan.py" 2>/dev/null || true

cat <<EOF

done. verify with:
  ls -la $TARGET | grep -E 'humanizer'

run the scanners:
  python3 $REPO/scripts/copy_scan.py <file>
  python3 $REPO/skills/structural-humanizer/scripts/structural_scan.py <file>
EOF
