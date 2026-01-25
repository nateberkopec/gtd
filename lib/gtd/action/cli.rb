require_relative 'api_client'
require_relative 'task_commands'
require_relative 'project_commands'
require_relative 'label_commands'
require_relative 'section_commands'

module GTD
  module Action
    class Error < StandardError; end
    class UnknownCommand < Error; end

    class CLI
      include TaskCommands
      include ProjectCommands
      include LabelCommands
      include SectionCommands

      HELP_TEXT = <<~HELP
        gtd-action - Todoist CLI wrapper for GTD actions/tasks

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
            --force                 Skip label validation

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
            --project, -P NAME      Move to project
            --section, -S NAME      Move to section (requires --project)
            --labels, -l LABELS     New labels

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
          P1/P3 = Unused
      HELP

      def initialize(argv)
        @api = ApiClient.new
        @command = nil
        @options = {}
        @passthrough = []

        parse_args(argv)
      end

      def run
        sync_todoist unless %w[help -h --help].include?(@command)

        case @command
        when 'list', 'l'
          list_tasks
        when 'add', 'a'
          add_task(@options)
        when 'complete', 'c', 'close'
          complete_task
        when 'delete', 'd'
          delete_task
        when 'modify', 'm'
          modify_task(@options)
        when 'projects'
          list_projects
        when 'project-add', 'project-create'
          add_project(@options)
        when 'project-update', 'project-rename'
          update_project(@options)
        when 'project-delete', 'project-remove'
          delete_project(@options)
        when 'labels', 'contexts'
          list_labels
        when 'label-add', 'label-create'
          add_label(@options)
        when 'label-update', 'label-rename'
          update_label(@options)
        when 'label-delete', 'label-remove'
          delete_label(@options)
        when 'section-list'
          list_sections(@options)
        when 'section-add', 'section-create'
          add_section(@options)
        when 'section-move'
          move_to_section(@options)
        when 'section-delete'
          delete_section(@options)
        when 'sync', 's'
          sync_todoist ? 0 : 1
        when 'inbox'
          list_inbox
        when 'waiting'
          list_waiting
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def parse_args(argv)
        i = 0
        while i < argv.length
          arg = argv[i]

          if @command.nil? && !arg.start_with?('-')
            @command = arg
          elsif arg.start_with?('-')
            case arg
            when '--filter', '-f'
              @options[:filter] = argv[i + 1]
              i += 1
            when '--text', '-t'
              @options[:text] = argv[i + 1]
              i += 1
            when '--id', '-i'
              @options[:id] = argv[i + 1]
              i += 1
            when '--name', '-n'
              @options[:name] = argv[i + 1]
              i += 1
            when '--parent-id'
              @options[:parent_id] = argv[i + 1]
              i += 1
            when '--priority', '-p'
              @options[:priority] = argv[i + 1].to_i
              i += 1
            when '--date', '-d'
              @options[:date] = argv[i + 1]
              i += 1
            when '--clear-date'
              @options[:clear_date] = true
            when '--project', '-P'
              @options[:project] = argv[i + 1]
              i += 1
            when '--section', '-S'
              @options[:section] = argv[i + 1]
              i += 1
            when '--labels', '-l'
              @options[:labels] = argv[i + 1]
              i += 1
            when '--force'
              @options[:force] = true
            else
              @passthrough << arg
            end
          else
            @passthrough << arg
          end

          i += 1
        end
      end

      def list_tasks
        args = []
        args += ['--filter', @options[:filter]] if @options[:filter]
        system('todoist', 'list', *args, *@passthrough) ? 0 : 1
      end

      def complete_task
        raise ArgumentError, '--id required for complete command' unless @options[:id]

        result = system('todoist', 'close', @options[:id], *@passthrough)
        puts @api.task_url(@options[:id])
        result ? 0 : 1
      end

      def delete_task
        raise ArgumentError, '--id required for delete command' unless @options[:id]

        result = system('todoist', 'delete', @options[:id], *@passthrough)
        puts @api.task_url(@options[:id])
        result ? 0 : 1
      end

      def list_inbox
        system('todoist', 'list', '--filter', '##Inbox') ? 0 : 1
      end

      def list_waiting
        system('todoist', 'list', '--filter', 'p4') ? 0 : 1
      end

      def sync_todoist
        system('todoist', 'sync')
      end
    end
  end
end
