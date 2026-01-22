function gtd_action_labels
    todoist labels
end

function gtd_action_label_add
    if test -z "$_flag_name"
        echo "Error: --name required for label-add command" >&2
        return 1
    end
    set name (string trim --left --chars "@" -- $_flag_name)
    set payload (todoist_name_payload "$name")
    set response (todoist_rest POST "labels" "$payload")
    todoist sync
    set label_id (echo $response | jq -r '.id')
    echo "Created label: $label_id @$name"
end

function gtd_action_label_update
    if test -z "$_flag_id"
        echo "Error: --id required for label-update command" >&2
        return 1
    end
    if test -z "$_flag_name"
        echo "Error: --name required for label-update command" >&2
        return 1
    end
    set name (string trim --left --chars "@" -- $_flag_name)
    set payload (todoist_name_payload "$name")
    todoist_rest POST "labels/$_flag_id" "$payload"
    todoist sync
    echo "Updated label: $_flag_id @$name"
end

function gtd_action_label_delete
    if test -z "$_flag_id"
        echo "Error: --id required for label-delete command" >&2
        return 1
    end
    set deleted_id $_flag_id
    todoist_rest DELETE "labels/$_flag_id"
    todoist sync
    echo "Deleted label: $deleted_id"
end
