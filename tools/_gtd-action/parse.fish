function parse_flags
    set -g _flag_filter ""
    set -g _flag_text ""
    set -g _flag_id ""
    set -g _flag_name ""
    set -g _flag_parent_id ""
    set -g _flag_priority "2"
    set -g _flag_date ""
    set -g _flag_clear_date false
    set -g _flag_project ""
    set -g _flag_section ""
    set -g _flag_labels ""
    set -g _passthrough

    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --filter -f
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_filter $argv[$i]
            case --text -t
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_text $argv[$i]
            case --id -i
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_id $argv[$i]
            case --name -n
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_name $argv[$i]
            case --parent-id
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_parent_id $argv[$i]
            case --priority -p
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_priority $argv[$i]
            case --date -d
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_date $argv[$i]
            case --clear-date
                set _flag_clear_date true
            case --project -P
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_project $argv[$i]
            case --section -S
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_section $argv[$i]
            case --labels -l
                set i (math $i + 1)
                test $i -le (count $argv); and set _flag_labels $argv[$i]
            case '*'
                set -a _passthrough $argv[$i]
        end
        set i (math $i + 1)
    end
end
