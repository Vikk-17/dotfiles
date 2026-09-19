```bash
#!/usr/bin/env bash

set -euo pipefail

# Default: current directory
ROOT_DIR="."

# Directories to exclude
EXCLUDES=()

usage() {
    cat <<EOF
Usage:
  $(basename "$0") [OPTIONS]

Remove Cargo target/ directories recursively.

Options:
  -r, --root DIR       Root directory to search (default: .)
  -e, --exclude DIR    Directory to exclude. Can be specified multiple times.
  -d, --dry-run        Show what would be deleted without deleting.
  -h, --help           Show this help.

Examples:
  $(basename "$0")
  $(basename "$0") --root ~/projects
  $(basename "$0") --exclude target/important
  $(basename "$0") -e ./project-a -e ./project-b
  $(basename "$0") --root ~/projects --exclude ~/projects/important --dry-run
EOF
}

DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--root)
            ROOT_DIR="$2"
            shift 2
            ;;
        -e|--exclude)
            EXCLUDES+=("$2")
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Convert root to an absolute path
ROOT_DIR="$(realpath "$ROOT_DIR")"

# Build find prune arguments for excluded directories
PRUNE_ARGS=()

for exclude in "${EXCLUDES[@]}"; do
    exclude="$(realpath -m "$exclude")"
    PRUNE_ARGS+=( -path "$exclude" -prune -o )
done

echo "Searching for Cargo target directories under:"
echo "  $ROOT_DIR"
echo

# Find target directories belonging to Cargo projects.
while IFS= read -r -d '' target_dir; do

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Would remove: $target_dir"
    else
        echo "Removing: $target_dir"
        rm -rf -- "$target_dir"
    fi

done < <(
    find "$ROOT_DIR" \
        "${PRUNE_ARGS[@]}" \
        -type d -name target -print0
)

echo
if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete."
else
    echo "Cargo build directories cleaned."
fi
```
