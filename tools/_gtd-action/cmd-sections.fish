function gtd_action_section_list
    if test -z "$_flag_project"
        echo "Error: --project required for section-list command" >&2
        return 1
    end
    set proj_id (lookup_project_id "$_flag_project")
    if test -z "$proj_id"
        echo "Error: project '$_flag_project' not found" >&2
        return 1
    end
    todoist_rest GET "sections?project_id=$proj_id" | jq -r '.[] | "  \(.id) \(.name)"'
end

function gtd_action_section_add
    if test -z "$_flag_name"
        echo "Error: --name required for section-add command" >&2
        return 1
    end
    if test -z "$_flag_project"
        echo "Error: --project required for section-add command" >&2
        return 1
    end
    set proj_id (lookup_project_id "$_flag_project")
    if test -z "$proj_id"
        echo "Error: project '$_flag_project' not found" >&2
        return 1
    end
    set payload "{\"name\":\"$_flag_name\",\"project_id\":\"$proj_id\"}"
    set response (todoist_rest POST "sections" "$payload")
    todoist sync
    set section_id (echo $response | jq -r '.id')
    if test -n "$section_id"
        echo "Created section: $section_id #$_flag_name in #$_flag_project"
    end
end

function gtd_action_section_move
    if test -z "$_flag_id"
        echo "Error: --id required for section-move command (task ID)" >&2
        return 1
    end
    if test -z "$_flag_project"
        echo "Error: --project required for section-move command" >&2
        return 1
    end
    if test -z "$_flag_section"
        echo "Error: --section required for section-move command" >&2
        return 1
    end
    set section_id (lookup_section_id "$_flag_project" "$_flag_section")
    if test -z "$section_id"
        echo "Error: Could not find section '$_flag_section' in project '$_flag_project'" >&2
        return 1
    end
    set uuid (uuidgen | tr -d '-')
    set cmd_json "{\"type\":\"item_move\",\"uuid\":\"$uuid\",\"args\":{\"id\":$_flag_id,\"section_id\":$section_id}}"
    set token (get_todoist_token)
    set response (curl --silent --show-error --fail -H "Authorization: Bearer $token" "https://api.todoist.com/sync/v9/sync" --data-urlencode "commands=[$cmd_json]")
    if echo $response | jq -e '.sync_status | all(. == "ok")' > /dev/null
        todoist sync
        echo "Task $_flag_id moved to section: #$_flag_section"
    else
        echo "Error: Failed to move task" >&2
        echo $response | jq . >&2
        return 1
    end
    task_url $_flag_id
end

function gtd_action_section_delete
    if test -z "$_flag_id"
        echo "Error: --id required for section-delete command" >&2
        return 1
    end
    set deleted_id $_flag_id
    todoist_rest DELETE "sections/$_flag_id"
    todoist sync
    echo "Deleted section: $deleted_id"
end
