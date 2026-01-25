require 'securerandom'

module GTD
  module Action
    module SectionCommands
      def list_sections(options)
        raise ArgumentError, '--project required for section-list command' unless options[:project]

        proj_id = @api.lookup_project_id(options[:project])
        raise ArgumentError, "project '#{options[:project]}' not found" unless proj_id

        sections = @api.get("sections?project_id=#{proj_id}")
        sections.each do |section|
          puts "  #{section['id']} #{section['name']}"
        end
        0
      end

      def add_section(options)
        raise ArgumentError, '--name required for section-add command' unless options[:name]
        raise ArgumentError, '--project required for section-add command' unless options[:project]

        proj_id = @api.lookup_project_id(options[:project])
        raise ArgumentError, "project '#{options[:project]}' not found" unless proj_id

        payload = { name: options[:name], project_id: proj_id }
        response = @api.post('sections', payload)
        sync_todoist

        if response && response['id']
          puts "Created section: #{response['id']} ##{options[:name]} in ##{options[:project]}"
        end
        0
      end

      def move_to_section(options)
        raise ArgumentError, '--id required for section-move command (task ID)' unless options[:id]
        raise ArgumentError, '--project required for section-move command' unless options[:project]
        raise ArgumentError, '--section required for section-move command' unless options[:section]

        section_id = @api.lookup_section_id(options[:project], options[:section])
        raise ArgumentError, "Could not find section '#{options[:section]}' in project '#{options[:project]}'" unless section_id

        uuid = SecureRandom.uuid.delete('-')
        args = { id: options[:id].to_i, section_id: section_id }

        @api.sync_command(uuid, 'item_move', args)
        sync_todoist

        puts "Task #{options[:id]} moved to section: ##{options[:section]}"
        puts @api.task_url(options[:id])
        0
      end

      def delete_section(options)
        raise ArgumentError, '--id required for section-delete command' unless options[:id]

        deleted_id = options[:id]
        @api.delete("sections/#{options[:id]}")
        sync_todoist
        puts "Deleted section: #{deleted_id}"
        0
      end

      private

      def sync_todoist
        system('todoist', 'sync')
      end
    end
  end
end
