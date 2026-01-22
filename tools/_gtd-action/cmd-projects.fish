function gtd_action_projects
    set token (get_todoist_token)
    set tmpfile (mktemp)
    curl --silent --show-error --fail -H "Authorization: Bearer $token" "https://api.todoist.com/rest/v2/projects" > $tmpfile
    _print_project_tree null 0 $tmpfile
    rm -f $tmpfile
end

function _print_project_tree --argument-names parent_id depth tmpfile
    set projects (cat $tmpfile | jq -r ".[] | select((.parent_id // \"null\") == \"$parent_id\") | \"\\(.id) \\(.name)\"")
    for proj in $projects
        set id (string split " " $proj)[1]
        set name (string sub -s (math (string length $id) + 2) -- $proj)
        set indent (string repeat -n $depth "  ")
        echo "$indent$id #$name"
        _print_project_tree $id (math $depth + 1) $tmpfile
    end
end

function gtd_action_project_add
    if test -z "$_flag_name"
        echo "Error: --name required for project-add command" >&2
        return 1
    end
    set payload (todoist_name_payload "$_flag_name")
    if test -n "$_flag_parent_id"
        set payload (string replace -r '\\}$' ",\"parent_id\":$_flag_parent_id}" -- $payload)
    end
    set response (todoist_rest POST "projects" "$payload")
    todoist sync
    set proj_id (echo $response | jq -r '.id')
    if test -n "$proj_id"
        project_url $proj_id
    end
end

function gtd_action_project_update
    if test -z "$_flag_id"
        echo "Error: --id required for project-update command" >&2
        return 1
    end
    if test -z "$_flag_name"
        echo "Error: --name required for project-update command" >&2
        return 1
    end
    set payload (todoist_name_payload "$_flag_name")
    todoist_rest POST "projects/$_flag_id" "$payload"
    todoist sync
    project_url $_flag_id
end

function gtd_action_project_delete
    if test -z "$_flag_id"
        echo "Error: --id required for project-delete command" >&2
        return 1
    end
    set deleted_id $_flag_id
    todoist_rest DELETE "projects/$_flag_id"
    todoist sync
    echo "Deleted project: $deleted_id"
end
