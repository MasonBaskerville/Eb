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
        if string match -r '^Output\s*:\s* "(.*)"$' "$trimmed" > /dev/null
            set -l msg (string match -r '^Output\s*:\s*"(.*)"$' "$trimmed")[2]
            echo -n "$msg"

        else if string match -r 'Set ([a-zA-Z_][a-zA-Z0-9_]*) = (.*)$' "$trimmed" > /dev/null
            set -l matches (string match -r 'Set ([a-zA-Z_][a-zA-Z0-9_]*) = (.*)$' "$trimmed")
            set -l var_name $matches[2]
            set -l var_val (string trim "$matches[3]")

            set -g $var_name $var_val
        
        else if string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed" > /dev/null
            set -l raw_msg (string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed")[2]
            if string match -r '\{([a-zA-Z_][a-zA-Z0-9_]*)\}' "$raw_msg" > /dev/null
                set -l var_match (string match -r '\{[a-zA-Z_][a-zA-Z0-9_]*\}' "$raw_msg")
                set -l var_name $var_match[2]
                set -l var_val $$var_name
                set -l final_msg (string replace -a "{$var_name}" "$var_val" "$raw_msg")
                echo $final_msg
            else
                echo $raw_msg
            end
        else
            echo "Syntax error: Unknown command '$trimmed"
        end
    end
end

run_script $argv[1]