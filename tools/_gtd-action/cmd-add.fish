function gtd_action_add
    if test -z "$_flag_text"
        echo "Error: --text required for add command" >&2
        return 1
    end
    if test -z "$_flag_labels"; and test $_flag_force = false
        echo "Did you want to add any context labels? Use 'gtd-action labels' to see available contexts, or use the assign-context skill. If no labels needed, use --force" >&2
        return 1
    end
    if test -n "$_flag_section"; and test -z "$_flag_project"
        echo "Error: --section requires --project" >&2
        return 1
    end
    set text_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $_flag_text))
    set payload "{\"content\":\"$text_escaped\""
    if test -n "$_flag_priority"
        set payload "$payload,\"priority\":$_flag_priority"
    end
    if test -n "$_flag_date"
        set date_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $_flag_date))
        set payload "$payload,\"due_string\":\"$date_escaped\""
    end
    if test -n "$_flag_project"
        set proj_id (lookup_project_id "$_flag_project")
        if test -n "$proj_id"
            set payload "$payload,\"project_id\":\"$proj_id\""
            if test -n "$_flag_section"
                set sect_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $_flag_section))
                set section_id (todoist_rest GET "sections?project_id=$proj_id" | jq -r ".[] | select(.name == \"$sect_escaped\") | .id")
                if test -n "$section_id"
                    set payload "$payload,\"section_id\":\"$section_id\""
                else
                    echo "Error: section '$_flag_section' not found in project '$_flag_project'" >&2
                    return 1
                end
            end
        else
            echo "Error: project '$_flag_project' not found" >&2
            return 1
        end
    end
    if test -n "$_flag_labels"
        set labels_json (string split "," $_flag_labels | string trim | xargs -I{} printf '"%s",' {} | string trim --right --chars=,)
        set payload "$payload,\"labels\":[$labels_json]"
    end
    set payload "$payload}"
    set response (todoist_rest POST "tasks" "$payload")
    todoist sync
    set task_id (echo $response | jq -r '.id')
    if test -n "$task_id"
        echo $task_id $_flag_text
        task_url $task_id
    end
end
