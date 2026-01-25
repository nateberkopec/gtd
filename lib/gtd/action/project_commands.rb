module GTD
  module Action
    module ProjectCommands
      def list_projects
        projects = @api.get('projects')
        print_project_tree(projects, nil, 0)
        0
      end

      def add_project(options)
        raise ArgumentError, '--name required for project-add command' unless options[:name]

        payload = { name: options[:name] }
        payload[:parent_id] = options[:parent_id] if options[:parent_id]

        response = @api.post('projects', payload)
        sync_todoist

        if response && response['id']
          puts @api.project_url(response['id'])
        end
        0
      end

      def update_project(options)
        raise ArgumentError, '--id required for project-update command' unless options[:id]
        raise ArgumentError, '--name required for project-update command' unless options[:name]

        payload = { name: options[:name] }
        @api.post("projects/#{options[:id]}", payload)
        sync_todoist
        puts @api.project_url(options[:id])
        0
      end

      def delete_project(options)
        raise ArgumentError, '--id required for project-delete command' unless options[:id]

        deleted_id = options[:id]
        @api.delete("projects/#{options[:id]}")
        sync_todoist
        puts "Deleted project: #{deleted_id}"
        0
      end

      private

      def print_project_tree(projects, parent_id, depth)
        parent_str = parent_id.nil? ? 'null' : parent_id.to_s

        projects
          .select { |p| (p['parent_id'] || 'null').to_s == parent_str }
          .each do |project|
            indent = '  ' * depth
            puts "#{indent}#{project['id']} ##{project['name']}"
            print_project_tree(projects, project['id'], depth + 1)
          end
      end

      def sync_todoist
        system('todoist', 'sync')
      end
    end
  end
end
