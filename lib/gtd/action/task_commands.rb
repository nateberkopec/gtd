require 'securerandom'

module GTD
  module Action
    module TaskCommands
      def add_task(options)
        raise ArgumentError, '--text required for add command' unless options[:text]

        unless options[:labels] || options[:force]
          raise ArgumentError, "Did you want to add any context labels? Use 'gtd-action labels' to see available contexts, or use the assign-context skill. If no labels needed, use --force"
        end

        if options[:section] && !options[:project]
          raise ArgumentError, '--section requires --project'
        end

        payload = { content: options[:text] }
        payload[:priority] = options[:priority] || 2
        payload[:due_string] = options[:date] if options[:date]

        if options[:project]
          proj_id = @api.lookup_project_id(options[:project])
          raise ArgumentError, "project '#{options[:project]}' not found" unless proj_id

          payload[:project_id] = proj_id

          if options[:section]
            section_id = @api.lookup_section_id(options[:project], options[:section])
            raise ArgumentError, "section '#{options[:section]}' not found in project '#{options[:project]}'" unless section_id

            payload[:section_id] = section_id
          end
        end

        if options[:labels]
          labels_array = options[:labels].split(',').map(&:strip)
          payload[:labels] = labels_array
        end

        response = @api.post('tasks', payload)
        sync_todoist

        if response && response['id']
          puts "#{response['id']} #{options[:text]}"
          puts @api.task_url(response['id'])
        end
        0
      end

      def modify_task(options)
        raise ArgumentError, '--id required for modify command' unless options[:id]

        update_payload = {}
        update_payload[:content] = options[:text] if options[:text]
        update_payload[:priority] = options[:priority] if options[:priority]

        if options[:date]
          update_payload[:due_string] = options[:date]
        elsif options[:clear_date]
          update_payload[:due_string] = 'no date'
        end

        if options[:labels]
          labels_array = options[:labels].split(',').map(&:strip)
          update_payload[:labels] = labels_array
        end

        move_project_id = nil
        move_section_id = nil

        if options[:project]
          move_project_id = @api.lookup_project_id(options[:project])
          raise ArgumentError, "project '#{options[:project]}' not found" unless move_project_id
        end

        if options[:section]
          raise ArgumentError, '--section requires --project' unless options[:project]

          move_section_id = @api.lookup_section_id(options[:project], options[:section])
          raise ArgumentError, "section '#{options[:section]}' not found in project '#{options[:project]}'" unless move_section_id
        end

        if update_payload.empty? && !move_project_id && !move_section_id
          raise ArgumentError, 'no changes specified for modify command'
        end

        @api.post("tasks/#{options[:id]}", update_payload) unless update_payload.empty?

        if move_project_id || move_section_id
          uuid = SecureRandom.uuid.delete('-')
          args = { id: options[:id].to_i }
          args[:project_id] = move_project_id if move_project_id
          args[:section_id] = move_section_id if move_section_id

          @api.sync_command(uuid, 'item_move', args)
        end

        sync_todoist
        puts @api.task_url(options[:id])
        0
      end

      private

      def sync_todoist
        system('todoist', 'sync')
      end
    end
  end
end
