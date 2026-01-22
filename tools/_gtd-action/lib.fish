function todoist_rest --argument-names method path payload
    set token (string match -r --groups-only '"token"\s*:\s*"([^"]+)"' (cat "$HOME/.config/todoist/config.json"))
    set url "https://api.todoist.com/rest/v2/$path"
    if test -n "$payload"
        curl --silent --show-error --fail -X "$method" -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$payload" "$url"
    else
        curl --silent --show-error --fail -X "$method" -H "Authorization: Bearer $token" "$url"
    end
end

function todoist_name_payload --argument-names name
    set name (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $name))
    printf '{"name":"%s"}' $name
end

function task_url --argument-names id
    echo "https://todoist.com/showTask?id=$id"
end

function project_url --argument-names id
    echo "https://todoist.com/showProject?id=$id"
end

function lookup_section_id --argument-names project_name section_name
    set proj_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $project_name))
    set sect_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $section_name))
    set proj_id (todoist_rest GET "projects" | jq -r ".[] | select(.name == \"$proj_escaped\") | .id")
    if test -z "$proj_id"
        echo ""
        return 1
    end
    set section_id (todoist_rest GET "sections?project_id=$proj_id" | jq -r ".[] | select(.name == \"$sect_escaped\") | .id")
    if test -n "$section_id"
        echo $section_id
    else
        echo ""
        return 1
    end
end

function lookup_project_id --argument-names project_name
    set proj_escaped (string replace -a '\\' '\\\\' -- (string replace -a '"' '\\"' -- $project_name))
    todoist_rest GET "projects" | jq -r ".[] | select(.name == \"$proj_escaped\") | .id"
end

function get_todoist_token
    string match -r --groups-only '"token"\s*:\s*"([^"]+)"' (cat "$HOME/.config/todoist/config.json")
end
