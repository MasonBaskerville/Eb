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
        
        if string match -r 'Set\s+([A-Z]+)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+=\s+(.*)$' "$trimmed" > /dev/null
            set -l matches (string match -r 'Set\s+([A-Z]+)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+=\s+(.*)$' "$trimmed")
            set -l var_type $matches[2]
            set -l var_name $matches[3]
            set -l var_val (string trim "$matches[4]")
        
        if test "$var_type" = "INT"
            set -l eval_expr "$var_val"
            for v in (string match -ra '[a-zA-Z_][a-zA-Z0-9_]*' "$eval_expr")
                if set -q $v
                    set -l v_val $$v
                    set eval_expr (string replace -a "$v" "$v_val" "$eval_expr")
                end
            end
            set -l calculated_val (math "$eval_expr" 2>/dev/null)
            if test $status -eq 0; and string match -r '^-?[0-9]+$' "$calculated_val" > /dev/null
                set -g $var_name $calculated_val
            else
                echo "TypeError : Variable '$var_name' expected type INT but got '$var_val'"
            end
        else if test "$var_type" = "STR"
            if string match -r '^"(.*)"$' "$var_val" > /dev/null
                set -l clean_val (string match -r '^"(.*)"$' "$var_val")[2]
                set -g $var_name $clean_val
            else
                echo "TypeError : Variable '$var_name' expected type STR but got '$var_val'"
            end
        else if test "$var_type" = "FLO"
            if string match -r '^[0-9]+\.[0-9]+$' "$var_val" > /dev/null
                set -g $var_name $var_val
            else
                echo "TypeError : Variable '$var_name' expected type FLO but got '$var_val'"
            end
        else if test "$var_type" = "BOO"
            if string match -r '^(true|false)$' "$var_val" > /dev/null
                set -g $var_name $var_val
            else    
                echo "TypeError : Variable '$var_name' expected type BOO but got '$var_val'"
            end
        else if test "$var_type" = "CHA"
            if string match -r '^\x27(.)\x27$' "$var_val" > /dev/null
                set -l clean_val (string match -r '^\x27(.)\x27$' "$var_val")[2]
                set -g $var_name $clean_val
            else
                echo "TypeError : Variable '$var_name' expected type CHA but got '$var_val'"
            end
        else
            echo "'$var_name' is not a valid data type"
        end


        else if string match -r '^Output\s*:\s*"(.*)"$' "$trimmed" > /dev/null
            set -l raw_msg (string match -r '^Output\s*:\s*"(.*)"$' "$trimmed")[2]
            if string match -q '*{\*}*' $raw_msg
            end

            if string  match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' $raw_msg > /dev/null
                set -l var_name (string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' "$raw_msg")[2]
                set -l var_val $$var_name
                set -l final_msg (string replace -a "{$var_name}" "$var_val" "$raw_msg")
                echo -n "$final_msg"
            else
                echo -n "$raw_msg"
            end
        else if string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed" > /dev/null
            set -l raw_msg (string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed")[2]
            if string match -q '*{\*}*' $raw_msg
            end

            if string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' $raw_msg > /dev/null
                set -l var_name (string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' "$raw_msg")[2]
                set -l var_val $$var_name
                set -l final_msg (string replace -a "{$var_name}" "$var_val" "$raw_msg")
                echo "$final_msg"
            else
                echo "$raw_msg"
            end
        else
            echo "Syntax error: Unknown command '$trimmed"
        end
    end
end

run_script $argv[1]

# need to do more complex mathematical operations next, like sin,cos,tan and powers and square roots.
#maybe ill turn this into a mathematical programming language, by including things like integration, series, matrices. etc