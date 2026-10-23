#!/usr/bin/env bash
# Symlink the skills listed in a manifest from this fork into a harness skills directory.
#
#   yeison/install.sh --target claude            # -> ~/.claude/skills
#   yeison/install.sh --target cursor            # -> ~/.cursor/skills
#   yeison/install.sh --target /some/skills/dir  # any directory
#
# Options:
#   --manifest FILE   skill names, one per line (default: yeison/skills-core.txt)
#   --dry-run         print what would happen, change nothing
#   --prune           also remove links into this fork that are not in the manifest
#
# Safe to rerun. It only creates or removes symlinks that point into this fork's
# skills/ directory, and it never overwrites a real file, directory or foreign link.

set -euo pipefail

FORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$FORK_DIR/skills"
MANIFEST="$FORK_DIR/yeison/skills-core.txt"
TARGET=""
DRY_RUN=0
PRUNE=0

die() { echo "error: $*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --target)   TARGET="${2:-}"; shift 2 ;;
    --manifest) MANIFEST="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    --prune)    PRUNE=1; shift ;;
    -h|--help)  sed -n '2,16p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)          die "unknown option: $1" ;;
  esac
done

case "$TARGET" in
  claude) TARGET="$HOME/.claude/skills" ;;
  cursor) TARGET="$HOME/.cursor/skills" ;;
  "")     die "missing --target (claude, cursor, or a directory)" ;;
esac
[ -f "$MANIFEST" ] || die "manifest not found: $MANIFEST"
[ -d "$SKILLS_SRC" ] || die "skills directory not found: $SKILLS_SRC"

run() { if [ "$DRY_RUN" -eq 1 ]; then echo "  (dry-run) $*"; else "$@"; fi; }

# Skill names from the manifest: strip comments and blank lines.
names=()
while IFS= read -r line; do
  line="${line%%#*}"
  line="$(echo "$line" | tr -d '[:space:]')"
  [ -n "$line" ] && names+=("$line")
done < "$MANIFEST"
[ "${#names[@]}" -gt 0 ] || die "manifest lists no skills: $MANIFEST"

echo "fork:     $FORK_DIR"
echo "target:   $TARGET"
echo "manifest: $MANIFEST (${#names[@]} skills)"
[ "$DRY_RUN" -eq 1 ] && echo "mode:     dry run"

run mkdir -p "$TARGET"

problems=0
for name in "${names[@]}"; do
  src="$SKILLS_SRC/$name"
  dest="$TARGET/$name"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "  MISSING  $name (no $src/SKILL.md)"; problems=$((problems + 1)); continue
  fi
  if [ -L "$dest" ]; then
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      echo "  ok       $name"
    else
      echo "  REFUSED  $name (existing link points to $current)"; problems=$((problems + 1))
    fi
  elif [ -e "$dest" ]; then
    echo "  REFUSED  $name (a real file or directory already exists at $dest)"; problems=$((problems + 1))
  else
    run ln -s "$src" "$dest"
    if [ "$DRY_RUN" -eq 1 ]; then echo "  would link  $name"; else echo "  linked   $name"; fi
  fi
done

if [ "$PRUNE" -eq 1 ] && [ -d "$TARGET" ]; then
  for link in "$TARGET"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$SKILLS_SRC"/*) ;;
      *) continue ;;
    esac
    base="$(basename "$link")"
    keep=0
    for name in "${names[@]}"; do [ "$name" = "$base" ] && keep=1; done
    if [ "$keep" -eq 0 ]; then
      run rm "$link"
      if [ "$DRY_RUN" -eq 1 ]; then echo "  would prune $base"; else echo "  pruned   $base"; fi
    fi
  done
fi

[ "$problems" -eq 0 ] || { echo "done with $problems problem(s)" >&2; exit 2; }
echo "done"
