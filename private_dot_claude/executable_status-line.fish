#!/usr/bin/env fish
#
# Claude Code status line, styled after bobthefish
# (https://github.com/oh-my-fish/theme-bobthefish).
#
# Reads Claude Code's JSON payload on stdin and renders powerline-style
# segments: model > usage > git > cost > duration.

# ---------------------------------------------------------------------------
# Read JSON payload
# ---------------------------------------------------------------------------

# Force C locale so printf renders numbers with `.` as decimal separator.
set -gx LC_ALL C

set -l input (cat)

if not command -q jq
    echo "status-line.fish: jq is required" >&2
    exit 1
end

set -l model_name      (echo $input | jq -r '.model.display_name // "Claude"')
set -l model_id        (echo $input | jq -r '.model.id // ""')
set -l transcript_path (echo $input | jq -r '.transcript_path // ""')
set -l cwd             (echo $input | jq -r '.workspace.current_dir // .cwd // "."')
set -l cost_usd        (echo $input | jq -r '.cost.total_cost_usd // 0')
set -l duration_ms     (echo $input | jq -r '.cost.total_duration_ms // 0')

test -d "$cwd"; and cd "$cwd"

# ---------------------------------------------------------------------------
# Load bobthefish helpers (glyphs, colors, segment functions)
# ---------------------------------------------------------------------------

set -l bob ~/.local/share/omf/themes/bobthefish/functions
source $bob/__bobthefish_glyphs.fish
source $bob/__bobthefish_colors.fish
source $bob/fish_prompt.fish

set -q theme_nerd_fonts;     or set -gx theme_nerd_fonts     yes
set -q theme_powerline_fonts; or set -gx theme_powerline_fonts yes
set -q theme_color_scheme;   or set -gx theme_color_scheme   dark

__bobthefish_glyphs
__bobthefish_colors $theme_color_scheme

# ---------------------------------------------------------------------------
# Formatters
# ---------------------------------------------------------------------------

function __claude_fmt_duration -a ms
    set -l s (math --scale=0 "$ms / 1000")
    if test $s -lt 60
        echo {$s}s
    else if test $s -lt 3600
        set -l m (math --scale=0 "$s / 60")
        set -l rs (math "$s - $m * 60")
        echo {$m}m {$rs}s
    else
        set -l h (math --scale=0 "$s / 3600")
        set -l rm (math --scale=0 "($s - $h * 3600) / 60")
        echo {$h}h {$rm}m
    end
end

function __claude_fmt_tokens -a n
    if test $n -ge 1000000
        printf '%.1fM' (math "$n / 1000000.0")
    else if test $n -ge 1000
        printf '%.1fk' (math "$n / 1000.0")
    else
        echo $n
    end
end

function __claude_context_limit -a model_id
    if string match -rq '\[1m\]' -- $model_id
        echo 1000000
    else
        echo 200000
    end
end

function __claude_last_usage_tokens -a transcript
    test -f "$transcript"; or return 1
    set -l line (awk '/"type":"assistant"/ { last = $0 } END { print last }' $transcript)
    test -z "$line"; and return 1
    echo $line | jq -r '
        (.message.usage.input_tokens // 0)
        + (.message.usage.cache_read_input_tokens // 0)
        + (.message.usage.cache_creation_input_tokens // 0)
    '
end

# ---------------------------------------------------------------------------
# Segment renderers
# ---------------------------------------------------------------------------

function __claude_segment_model -S -a name
    __bobthefish_start_segment $color_username
    echo -ns $name ' '
end

function __claude_segment_usage -S -a transcript -a model_id
    set -l tokens (__claude_last_usage_tokens $transcript)
    test -z "$tokens"; and return
    test "$tokens" = "0"; and return

    set -l limit (__claude_context_limit $model_id)
    set -l pct (math --scale=0 "$tokens * 100 / $limit")

    set -l usage_color $color_virtualfish
    if test $pct -ge 80
        set usage_color $color_repo_dirty
    else if test $pct -ge 50
        set usage_color $color_repo_staged
    end

    __bobthefish_start_segment $usage_color
    echo -ns (__claude_fmt_tokens $tokens) '/' (__claude_fmt_tokens $limit) " ($pct%) "
end

function __claude_segment_git -S
    # Mirrors __bobthefish_prompt_git's branch+flags segment, without the
    # project-path segment that wrapper prepends.
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l dirty (command git diff --no-ext-diff --quiet --exit-code 2>/dev/null; or echo -n $git_dirty_glyph)
    set -l staged (command git diff --cached --no-ext-diff --quiet --exit-code 2>/dev/null; or echo -n $git_staged_glyph)
    set -l stashed (__bobthefish_git_stashed)
    set -l ahead (__bobthefish_git_ahead)

    set -l untracked ''
    set -l untracked_files (command git ls-files --other --exclude-standard --directory --no-empty-directory 2>/dev/null | head -n 1)
    test -n "$untracked_files"; and set untracked $git_untracked_glyph

    set -l flags "$dirty$staged$stashed$ahead$untracked"
    test -n "$flags"; and set flags " $flags"

    set -l flag_colors $color_repo
    if test -n "$dirty"
        set flag_colors $color_repo_dirty
    else if test -n "$staged"
        set flag_colors $color_repo_staged
    end

    __bobthefish_start_segment $flag_colors
    echo -ns (__bobthefish_git_branch) $flags ' '
end

function __claude_segment_cost -S -a usd
    __bobthefish_start_segment $color_aws_vault
    printf '$%.4f ' $usd
end

function __claude_segment_duration -S -a ms
    __bobthefish_start_segment $color_k8s
    echo -ns (__claude_fmt_duration $ms) ' '
end

# ---------------------------------------------------------------------------
# Render
# ---------------------------------------------------------------------------

set -g __bobthefish_current_bg

__claude_segment_model    $model_name
__claude_segment_usage    $transcript_path $model_id
__claude_segment_git
__claude_segment_cost     $cost_usd
__claude_segment_duration $duration_ms

__bobthefish_finish_segments
