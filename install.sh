#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
source_dir="$script_dir/visual-analysis"
if [ ! -f "$source_dir/SKILL.md" ]; then
    echo "The visual-analysis folder is missing. Extract the entire archive first." >&2
    exit 1
fi
target_choice=""
if [ "$#" -gt 0 ]; then target_choice=$1; shift; fi
skills_override=""
backup_root="$HOME/.visual-analysis/backups"
dry_run=false
while [ "$#" -gt 0 ]; do
    case "$1" in
        --skills-dir) [ "$#" -ge 2 ] || exit 2; skills_override=$2; shift 2 ;;
        --backup-dir) [ "$#" -ge 2 ] || exit 2; backup_root=$2; shift 2 ;;
        --dry-run) dry_run=true; shift ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done
if [ -z "$target_choice" ]; then
    printf 'Visual Analysis installation\n1. Codex\n2. Claude Code\n3. Both\nChoose 1, 2 or 3: '
    read -r selection
    case "$selection" in 1) target_choice=codex ;; 2) target_choice=claude ;; 3) target_choice=both ;; *) exit 2 ;; esac
fi
case "$target_choice" in codex|claude) selected_targets=$target_choice ;; both) selected_targets="codex claude" ;; *) echo "Use codex, claude or both." >&2; exit 2 ;; esac
if [ -n "$skills_override" ] && [ "$target_choice" = both ]; then
    echo "Use a custom skills directory with a single target." >&2
    exit 2
fi
for selected_target in $selected_targets; do
    if [ -n "$skills_override" ]; then skills_root=$skills_override
    elif [ "$selected_target" = codex ]; then skills_root="$HOME/.agents/skills"
    else skills_root="$HOME/.claude/skills"; fi
    destination="$skills_root/visual-analysis"
    if [ "$dry_run" = true ]; then
        echo "Would install for $selected_target at $destination"
        continue
    fi
    mkdir -p "$skills_root"
    skills_root=$(CDPATH= cd -- "$skills_root" && pwd -P)
    destination="$skills_root/visual-analysis"
    case "$source_dir/" in "$destination/"*) echo "Source and destination must be separate." >&2; exit 1 ;; esac
    case "$destination/" in "$source_dir/"*) echo "Source and destination must be separate." >&2; exit 1 ;; esac
    if [ -L "$destination" ] || { [ -e "$destination" ] && [ ! -d "$destination" ]; }; then
        echo "The destination is a file or symbolic link. Move it before installing." >&2
        exit 1
    fi
    saved_copy=""
    if [ -d "$destination" ]; then
        mkdir -p "$backup_root"
        backup_root=$(CDPATH= cd -- "$backup_root" && pwd -P)
        case "$backup_root/" in "$destination/"*) echo "Backups must be outside the installed skill." >&2; exit 1 ;; esac
        backup_container=$(mktemp -d "$backup_root/$selected_target-$(date +%Y%m%d-%H%M%S).XXXXXX")
        saved_copy="$backup_container/visual-analysis"
        mv "$destination" "$saved_copy"
        echo "Previous version saved at $saved_copy"
    fi
    if ! { mkdir -p "$destination" && cp -R "$source_dir/." "$destination/" && [ -f "$destination/SKILL.md" ]; }; then
        if [ -n "$saved_copy" ]; then
            if [ -d "$destination" ]; then mv "$destination" "$backup_container/failed-install"; fi
            mv "$saved_copy" "$destination"
        fi
        echo "Installation failed." >&2
        exit 1
    fi
    echo "Installed for $selected_target at $destination"
done
if [ "$dry_run" = true ]; then
    echo "Dry run complete. No files were changed."
else
    echo "Start a new Codex or Claude Code session and invoke Visual Analysis."
    echo "For Claude Chat and Cowork, upload visual-analysis-skill.zip in Customize > Skills."
fi
