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

        if string match -r '^SAY "(.*)"$' "$trimmed" > /dev/null
            set -l msg (string match -r '^SAY "(.*)"$' "$trimmed")[2]
            echo "$msg"
        else
            echo "Syntax error: Unknown command '$trimmed"
        end
    end
end

run_script $argv[1]