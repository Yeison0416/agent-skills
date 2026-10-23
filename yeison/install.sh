#!/usr/bin/env bash
# Symlink skills (and subagents) from this fork into a harness directory.
#
#   yeison/install.sh --target claude            # skills -> ~/.claude/skills, agents -> ~/.claude/agents
#   yeison/install.sh --target cursor            # skills -> ~/.cursor/skills
#   yeison/install.sh --target /some/skills/dir  # any skills directory (e.g. a project's .claude/skills)
#
# Options:
#   --manifest FILE   skill names, one per line (default: yeison/skills-core.txt)
#   --agents FILE     subagent names, one per line (default for --target claude: yeison/agents-core.txt)
#   --dry-run         print what would happen, change nothing
#   --prune           also remove skill links into this fork that are not in the manifest
#
# Skills refer to shared files as ../../references/<file>.md, so a `references` link is
# also created next to the skills directory (e.g. ~/.claude/references). Subagents are
# linked into an `agents` directory next to it.
#
# Safe to rerun. It only creates or removes symlinks that point into this fork, and it
# never overwrites a real file, directory or foreign link.

set -euo pipefail

FORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$FORK_DIR/skills"
MANIFEST="$FORK_DIR/yeison/skills-core.txt"
AGENTS_MANIFEST=""
TARGET=""
DRY_RUN=0
PRUNE=0

die() { echo "error: $*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --target)   TARGET="${2:-}"; shift 2 ;;
    --manifest) MANIFEST="${2:-}"; shift 2 ;;
    --agents)   AGENTS_MANIFEST="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    --prune)    PRUNE=1; shift ;;
    -h|--help)  sed -n '2,20p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)          die "unknown option: $1" ;;
  esac
done

case "$TARGET" in
  claude) TARGET="$HOME/.claude/skills"
          [ -z "$AGENTS_MANIFEST" ] && AGENTS_MANIFEST="$FORK_DIR/yeison/agents-core.txt" ;;
  cursor) TARGET="$HOME/.cursor/skills" ;;
  "")     die "missing --target (claude, cursor, or a directory)" ;;
esac
[ -f "$MANIFEST" ] || die "manifest not found: $MANIFEST"
[ -d "$SKILLS_SRC" ] || die "skills directory not found: $SKILLS_SRC"
[ -z "$AGENTS_MANIFEST" ] || [ -f "$AGENTS_MANIFEST" ] || die "agents manifest not found: $AGENTS_MANIFEST"

run() { if [ "$DRY_RUN" -eq 1 ]; then echo "  (dry-run) $*"; else "$@"; fi; }

# Names from a manifest: strip comments and blank lines. Sets the global array `names`.
read_names() {
  names=()
  local line
  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(echo "$line" | tr -d '[:space:]')"
    [ -n "$line" ] && names+=("$line")
  done < "$1"
  return 0
}

problems=0

# link_item SRC DEST LABEL: create DEST -> SRC unless it exists. Counts problems, never overwrites.
link_item() {
  local src="$1" dest="$2" label="$3" current
  if [ -L "$dest" ]; then
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      echo "  ok       $label"
    else
      echo "  REFUSED  $label (existing link points to $current)"; problems=$((problems + 1))
    fi
  elif [ -e "$dest" ]; then
    echo "  REFUSED  $label (a real file or directory already exists at $dest)"; problems=$((problems + 1))
  else
    run ln -s "$src" "$dest"
    if [ "$DRY_RUN" -eq 1 ]; then echo "  would link  $label"; else echo "  linked   $label"; fi
  fi
}

read_names "$MANIFEST"
[ "${#names[@]}" -gt 0 ] || die "manifest lists no skills: $MANIFEST"
skill_names=("${names[@]}")

echo "fork:     $FORK_DIR"
echo "target:   $TARGET"
echo "manifest: $MANIFEST (${#skill_names[@]} skills)"
[ "$DRY_RUN" -eq 1 ] && echo "mode:     dry run"

run mkdir -p "$TARGET"

for name in "${skill_names[@]}"; do
  if [ ! -f "$SKILLS_SRC/$name/SKILL.md" ]; then
    echo "  MISSING  $name (no $SKILLS_SRC/$name/SKILL.md)"; problems=$((problems + 1)); continue
  fi
  link_item "$SKILLS_SRC/$name" "$TARGET/$name" "$name"
done

# Shared references, next to the skills directory.
if [ -d "$FORK_DIR/references" ]; then
  link_item "$FORK_DIR/references" "$(dirname "$TARGET")/references" "references"
fi

# Subagents, next to the skills directory.
if [ -n "$AGENTS_MANIFEST" ]; then
  read_names "$AGENTS_MANIFEST"
  agents_dir="$(dirname "$TARGET")/agents"
  echo "agents:   $agents_dir (${#names[@]} agents)"
  run mkdir -p "$agents_dir"
  for name in "${names[@]}"; do
    if [ ! -f "$FORK_DIR/agents/$name.md" ]; then
      echo "  MISSING  agent $name (no $FORK_DIR/agents/$name.md)"; problems=$((problems + 1)); continue
    fi
    link_item "$FORK_DIR/agents/$name.md" "$agents_dir/$name.md" "agent $name"
  done
fi

if [ "$PRUNE" -eq 1 ] && [ -d "$TARGET" ]; then
  for link in "$TARGET"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$SKILLS_SRC"/*) ;;
      *) continue ;;
    esac
    base="$(basename "$link")"
    keep=0
    for name in "${skill_names[@]}"; do [ "$name" = "$base" ] && keep=1; done
    if [ "$keep" -eq 0 ]; then
      run rm "$link"
      if [ "$DRY_RUN" -eq 1 ]; then echo "  would prune $base"; else echo "  pruned   $base"; fi
    fi
  done
fi

[ "$problems" -eq 0 ] || { echo "done with $problems problem(s)" >&2; exit 2; }
echo "done"
