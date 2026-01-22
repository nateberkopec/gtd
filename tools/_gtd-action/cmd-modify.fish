function gtd_action_modify
    if test -z "$_flag_id"
        echo "Error: --id required for modify command" >&2
        return 1
    end
    set payload "{"
    set has_field false
    if test -n "$_flag_text"
        set text_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $_flag_text))
        set payload "$payload\"content\":\"$text_escaped\""
        set has_field true
    end
    if test -n "$_flag_priority"
        if $has_field
            set payload "$payload,"
        end
        set payload "$payload\"priority\":$_flag_priority"
        set has_field true
    end
    if test -n "$_flag_date"
        if $has_field
            set payload "$payload,"
        end
        set date_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $_flag_date))
        set payload "$payload\"due_string\":\"$date_escaped\""
        set has_field true
    else if test "$_flag_clear_date" = true
        if $has_field
            set payload "$payload,"
        end
        set payload "$payload\"due_string\":\"no date\""
        set has_field true
    end
    if test -n "$_flag_labels"
        if $has_field
            set payload "$payload,"
        end
        set labels_json (string split "," $_flag_labels | string trim | xargs -I{} printf '"%s",' {} | string trim --right --chars=,)
        set payload "$payload\"labels\":[$labels_json]"
        set has_field true
    end
    set payload "$payload}"
    todoist_rest POST "tasks/$_flag_id" "$payload"
    todoist sync
    task_url $_flag_id
end
