#!/usr/bin/env fish

function run_script --argument file_path
    if not test -f "$file_path"
        echo "error: File '$file_path' not found"
        return 1
    end

    #tells it to act like an interpreter
    for line in (cat "$file_path")
        set -l trimmed (string trim "$line")

        if test -z "$trimmed"; or string match -q "#*" "$trimmed"
            continue
        end    

#VARIABLE HANDLING AND MANIPULATION--------------------------------------------------------

        if string match -qr '^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(.+)$' "$trimmed"    
            set -l match_arr (string match -r '^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(.+)$' "$trimmed" )
            set -l var_name $match_arr[2]
            set -l var_val $match_arr[3]
            if not set -q $var_name
                echo "NameError : variable '$var_name' is not defined, use 'Set' to define a variable"
                return 1
            end
            set -l var_type_var "__type_$var_name"
            set -l expected_type $$var_type_var
            if test "$var_val" = "READ"
                read -l user_input

                #INT data type
                if test "$expected_type" = "INT"
                    if string match -r -- '^-?[0-9]+$' "$user_input" > /dev/null
                        set -g $var_name "$user_input"
                    else
                        echo "TypeError : variable '$var_name' expected type INT, but got '$user_input'"
                        return 1
                    end

                #FLO data type
                else if test "$expected_type" = "FLO"
                    if string match -r -- '^-?[0-9]+(\.[0-9]+)$' "$user_input" > /dev/null
                        if not string match -r '\.' "$user_input" > /dev/null
                            set user_input "$user_input.0"
                        end
                        set -g $var_name "$user_input"
                    else
                        echo "TypeError : variable '$var_name' expected type FLO, but got '$user_input'"
                        return 1
                    end
                
                #STR data type
                else if test "$expected_type" = "STR"
                    set -g $var_name "$user_input"
                
                #CHA data type
                else if test "$expected_type" = "CHA"
                    if string match -r -- '^-?.$' "$user_input" > /dev/null
                        set -l clean_val (string match -r '^-?.$' "$user_input")
                        set -g $var_name "$clean_val"
                    else
                        echo "TypeError : variable '$var_name' expected type CHA, but got '$user_input'"
                        return 1
                    end
                else if test "$expected_type" = "BOO"
                    if string match -r -- '^(true|false)$' "$user_input" > /dev/null
                        set -g $var_name "$user_input"
                    else
                        echo "TypeError : variable '$var_name' expected type BOO, but got '$user_input'"
                        return 1
                    end
                else
                    echo "TypeError : variable '$var_name' expected type STR, but got '$user_input'"
                    return 1
                end
                continue
            end

            if set -q $var_name
                set -l eval_expr "$var_val"
                for v in (string match -ra '[a-zA-Z_][a-zA-Z0-9_]*' "$eval_expr")
                   if set -q $v
                        set -l v_val $$v 
                        set eval_expr (string replace -ra "\\b$v\\b" "$v_val" "$eval_expr")
                    end
                end

                set -l calculated_val (math "$eval_expr" 2>/dev/null)
                if test $status -eq 0
                    set -g $var_name $calculated_val
                else
                    echo "Error : invalid expression for reassignment of '$var_name'"
                end
            else
                echo "NameError : variable '$var_name' is not defined, use 'Set' first"
            end
        continue
        end
        
        #variable creation
        if string match -r 'Set\s+([A-Z]+)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+=\s+(.*)$' "$trimmed" > /dev/null
            set -l matches (string match -r 'Set\s+([A-Z]+)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+=\s+(.*)$' "$trimmed")
            set -l var_type $matches[2]
            set -l var_name (string trim "$matches[3]")
            set -l var_val (string trim "$matches[4]")

        set -g "__type_$var_name" "$var_type"
        if test "$var_val" = "READ"
            read -l user_input

            #INT data type
            if test "$var_type" = "INT"
                if string match -r -- '^-?[0-9]+$' "$user_input" > /dev/null
                    set -g $var_name "$user_input"
                else
                    echo "TypeError: variable '$var_name' expected type INT, but got '$user_input'"
                    return 1
                end
            
            #FLO data type
            else if test "$var_type" = "FLO"
                if string match -r -- '^-?[0-9]+(\.[0-9]+)$?' "$user_input" > /dev/null
                    if not string match -r '\.' "$user_input" > /dev/null
                        set user_input "$user_input.0"
                    end
                    set -g $var_name "$user_input"
                else
                    echo "TypeError : variable '$var_name' expected type FLO, but got '$user_input'"
                    return 1
                end
            
            #STR data type
            else if test "$var_type" = "STR"
                set -g $var_name "$user_input"
            
            #CHA data type
            else if test "$var_type" = "CHA"
                if string match -r -- '^-?.$' "$user_input" > /dev/null
                    set -l clean_val (string match -r '^-?.$' "$user_input")[2]
                    set -g $var_name "$clean_val"
                else
                    echo "TypeError : variable '$var_name' expected CHA type, but got '$user_input'"
                    return 1
                end

            #BOO data type
            else if test "$var_type" = "BOO"
                if string match -r -- '^(true|false)$' "$user_input" > /dev/null
                    set -g $var_name "$user_input"
                else
                    echo "TypeError : variable '$var_name' expected type BOO, but got '$user_input'"
                    return 1
                end
            else
                echo "NameError: : variable does not exist, create a variable using 'Set'"
                return 1
            end
            continue
        end

#DATA TYPES -------------------------------------------------------------------------------------

        #INT DATA TYPE
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

        #FLO DATA TYPE
        else if test "$var_type" = "FLO"
            set -l eval_expr "$var_val"
            for v in (string match -ra '[a-zA-Z_][a-zA-Z0-9_]*' "$eval_expr")
                if set -q $v    
                    set -l v_val $$v
                    set eval_expr (string replace -ra "\\b$v\\b" "$v_val" "$eval_expr")
                end
            end
            #sq(base,exponent) function
            while string match -qr 'sq\s*\((.*?),\s*(.*?)\)' "$eval_expr"
                set -l sq_match (string match -r 'sq\s*\((.*?),\s*(.*?)\)' "$eval_expr")
                set -l full_match $sq_match[1]
                set -l base (string trim "$sq_match[2]")
                set -l exp (string trim "$sq_match[3]")
                set eval_expr (string replace "$full_match" "pow($base,$exp)" "$eval_expr")
            end

            #rt(num,root)
            while string match -qr 'rt\s*\((.*?),\s*(.*?)\)' "$eval_expr"
                set -l rt_match (string match -r 'rt\s*\((.*?),\s*(.*?)\)' "$eval_expr")
                set -l full_match $rt_match[1]
                set -l base (string trim "$rt_match[2]")
                set -l root (string trim "$rt_match[3]")
                set eval_expr (string replace "$full_match" "pow($base , 1.0/$root)" "$eval_expr")
            end
            set -l calculated_val (math "$eval_expr" 2>/dev/null)
            if test $status -eq 0; and string match -r -- '^-?[0-9]+(\.[0-9]+)?$' "$calculated_val" > /dev/null
                if not string match -r '\.' "$calculated_val" > /dev/null
                    set calculated_val "$calculated_val.0"
                end
                
                set -g $var_name $calculated_val
                
            else
                echo "TypeError : variable '$var_name' expected type FLO but got '$var_val'"
            end
            #if string match -r '^[0-9]+\.[0-9]+$' "$var_val" > /dev/null
            #    set -g $var_name $var_val
            #else
            #    echo "TypeError : Variable '$var_name' expected type FLO but got '$var_val'"
            #end
        
        #STRING DATA TYPE
        else if test "$var_type" = "STR"
            if string match -r '^"(.*)"$' "$var_val" > /dev/null
                set -l clean_val (string match -r '^"(.*)"$' "$var_val")[2]
                set -g $var_name $clean_val
            else
                echo "TypeError : Variable '$var_name' expected type STR but got '$var_val'"
            end

        #BOO DATA TYPE
        else if test "$var_type" = "BOO"
            if string match -r '^(true|false)$' "$var_val" > /dev/null
                set -g $var_name $var_val
            else    
                echo "TypeError : Variable '$var_name' expected type BOO but got '$var_val'"
            end

        #CHA DATA TYPE
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

#OUTPUT FUNCTIONS -----------------------------------------------------------------
        #outputs on the same line like C# console.write();
        else if string match -r '^Output\s*:\s*"(.*)"$' "$trimmed" > /dev/null
            set -l raw_msg (string match -r '^Output\s*:\s*"(.*)"$' "$trimmed")[2]
            if string match -q '*{\*}*' $raw_msg
            end

            if string  match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' $raw_msg > /dev/null
                set -l var_name (string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' "$raw_msg")[2]
                if not set -q $var_name
                    echo "NameError : variable '$var_name' is not defined"
                    return 1
                end
                set -l var_val $$var_name
                
                set -l final_msg (string replace -a "{$var_name}" "$var_val" "$raw_msg")
                echo -n "$final_msg"
            else
                echo -n "$raw_msg"
            end

        #outputs a line, like C# console.writeline();
        else if string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed" > /dev/null
            set -l raw_msg (string match -r '^OutputLine\s*:\s*"(.*)"$' "$trimmed")[2]
            if string match -q '*{\*}*' $raw_msg
            end

            if string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' $raw_msg > /dev/null
                set -l var_name (string match -r '{([a-zA-Z_][a-zA-Z0-9_]*)}' "$raw_msg")[2]
                if not set -q $var_name
                    echo "NameError : variable '$var_name' is not defined"
                    return 1
                end
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

#error message and if block needed to chekc if a variable exists before outputting it.