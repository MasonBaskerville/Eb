#!/usr/bin/env fish

function run_script --argument file_path
    if not test -f "$file_path"
        echo "error: File '$file_path' not found"
        return 1
    end

    for line in (cat "$file_path")
        set -l trimmed (string trim "$line")

        if test -z "$trimmed"; or string match -q "#*" "$trimmed"
            continue
        end
        if string match -r '^OutputLine\s*:\s* "(.*)"$' "$trimmed" > /dev/null
            set -l msg (string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed")[2]
            echo "$msg"
        
        else if string match -r '^Output\s*:\s* "(.*)"$' "$trimmed" > /dev/null
            set -l msg (string match -r '^Output\s*:\s*"(.*)"$' "$trimmed")[2]
            echo -n "$msg"

        else if string match -r 'Set ([a-zA-Z_][a-zA-Z0-9_]*) = (.*)$' "$trimmed" > /dev/null
            set -l matches (string match -r 'Set ([a-zA-Z_][a-zA-Z0-9_]*) = (.*)$' "$trimmed")
            set -l var_name $matches[2]
            set -l var_val $matches[3]

            set -g $var_name $var_val
        
        else if string match -r '^OutputLine\s*:\s*([a-zA-Z_][a-z-A-Z-0-9_]*)$' "$trimmed" > /dev/null
            set -l var_name (string match -r '^OutputLine\s*:\s*([a-zA-Z_][a-z-A-Z-0-9_]*)$' "$trimmed")[2] 
            echo $$var_name
        else
            echo "Syntax error: Unknown command '$trimmed"
        end
    end
end

run_script $argv[1]