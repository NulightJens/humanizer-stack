#!/usr/bin/env bash
# install.sh - link (or copy) the humanizer skills into ~/.claude/skills/
#
#   ./install.sh              symlink both skills (updates follow git pull)
#   ./install.sh --copy       install independent copies instead
#   ./install.sh --project    install into ./.claude/skills/ of the current dir
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
    --project) TARGET="$PWD/.claude/skills" ;;
    --force)   FORCE=1 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

IS_WINDOWS=0
case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) IS_WINDOWS=1 ;;
esac

mkdir -p "$TARGET"
echo "installing into $TARGET (mode: $MODE)"

for skill in "${SKILLS[@]}"; do
  src="$REPO/skills/$skill"
  dst="$TARGET/$skill"

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ "$FORCE" -eq 0 ]]; then
      echo "  SKIP $skill: already exists at $dst"
      echo "       re-run with --force to replace it (a backup is kept)"
      continue
    fi
    backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "  backed up existing $skill to $(basename "$backup")"
  fi

  if [[ "$MODE" == link ]]; then
    if [[ "$IS_WINDOWS" -eq 1 ]]; then
      # Git Bash silently turns `ln -s` into a deep copy unless MSYS is
      # configured for native symlinks, which breaks `git pull` updates
      # without saying so. A directory junction is the reliable equivalent
      # and needs no elevation.
      win_src="$(cygpath -w "$src")"
      win_dst="$(cygpath -w "$dst")"
      if cmd //c mklink //J "$win_dst" "$win_src" > /dev/null 2>&1; then
        echo "  junctioned $skill"
      else
        cp -R "$src" "$dst"
        echo "  copied $skill (junction refused; re-run install.sh after a git pull)"
      fi
    elif ln -s "$src" "$dst" 2>/dev/null; then
      echo "  linked $skill"
    else
      cp -R "$src" "$dst"
      echo "  copied $skill (symlink refused; re-run install.sh after a git pull)"
    fi
  else
    cp -R "$src" "$dst"
    echo "  copied $skill"
  fi
done

chmod +x "$REPO/skills/humanizer/scripts/copy_scan.py" \
         "$REPO/skills/structural-humanizer/scripts/structural_scan.py" 2>/dev/null || true

cat <<EOF

done. verify with:
  ls -la $TARGET | grep -E 'humanizer'

run the scanners:
  python3 $REPO/skills/humanizer/scripts/copy_scan.py <file>
  python3 $REPO/skills/structural-humanizer/scripts/structural_scan.py <file>
EOF
