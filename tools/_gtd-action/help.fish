function gtd_action_help
    echo "gtd-action - Todoist CLI wrapper for GTD actions/tasks

Commands:
  list                    List tasks
    --filter, -f FILTER     Todoist filter syntax

  add                     Add a new task
    --text, -t TEXT         Task text (required)
    --priority, -p NUM      Priority (1-4)
    --date, -d DATE         Due date
    --project, -P NAME      Project name
    --section, -S NAME      Section name (requires --project)
    --labels, -l LABELS     Label names (comma-separated)

  complete                Mark task complete
    --id, -i ID             Task ID (required)

  delete                  Delete a task
    --id, -i ID             Task ID (required)

  modify                  Modify a task
    --id, -i ID             Task ID (required)
    --text, -t TEXT         New task text
    --priority, -p NUM      New priority
    --date, -d DATE         New due date
    --clear-date            Remove due date

  projects                List all projects

  project-add             Create a project
    --name, -n NAME         Project name (required)
    --parent-id ID          Parent project ID

  project-update          Update a project name
    --id, -i ID             Project ID (required)
    --name, -n NAME         New name (required)

  project-delete          Delete a project
    --id, -i ID             Project ID (required)

  section-list            List sections in a project
    --project, -P NAME      Project name (required)

  section-add             Create a section in a project
    --name, -n NAME         Section name (required)
    --project, -P NAME      Project name (required)

  section-move            Move a task to a section
    --id, -i ID             Task ID (required)
    --project, -P NAME      Project name (required)
    --section, -S NAME      Target section name (required)

  section-delete          Delete a section (moves tasks to project inbox)
    --id, -i ID             Section ID (required)

  labels                  List all labels (contexts)

  label-add               Create a label
    --name, -n NAME         Label name (required)

  label-update            Update a label name
    --id, -i ID             Label ID (required)
    --name, -n NAME         New name (required)

  label-delete            Delete a label
    --id, -i ID             Label ID (required)

  sync                    Sync with Todoist server
  inbox                   List inbox items only
  waiting                 List waiting-for items (P4)

Priority conventions:
  P4 = Waiting/blocked
  P2 = Workable (default)
  P1/P3 = Unused"
end
