#!/usr/bin/env fish

set max_lines 100
if set -q MAX_TOOL_LINES
    set max_lines $MAX_TOOL_LINES
else if set -q MAX_BIN_LINES
    set max_lines $MAX_BIN_LINES
end

set pattern "tools/gtd-*"
set files tools/gtd-*
if set -q TOOLS_GLOB
    set pattern $TOOLS_GLOB
    set files $TOOLS_GLOB
else if set -q BIN_GLOB
    set pattern $BIN_GLOB
    set files $BIN_GLOB
end

set existing_files
for file in $files
    if test -e "$file"
        set -a existing_files $file
    end
end
set files $existing_files
if test (count $files) -eq 0
    echo "No files matched $pattern"
    exit 1
end

set failures 0
for file in $files
    set line_count 0
    while read -l line
        set trimmed (string trim --left -- $line)
        if test -z "$trimmed"
            continue
        end
        if string match -qr '^#' -- $trimmed
            continue
        end
        set line_count (math $line_count + 1)
    end < "$file"
    if test $line_count -gt $max_lines
        if type -q gum
            gum style --foreground 1 "✗ $file: $line_count lines"
        else
            echo "✗ $file: $line_count lines"
        end
        set failures (math $failures + 1)
    end
end

if test $failures -gt 0
    if type -q gum
        gum style --foreground 1 "Tool script length check failed (max $max_lines lines)."
    else
        echo "Tool script length check failed (max $max_lines lines)."
    end
    exit 1
end

if type -q gum
    gum style --foreground 2 "Tool script length check OK (max $max_lines lines)."
else
    echo "Tool script length check OK (max $max_lines lines)."
end
