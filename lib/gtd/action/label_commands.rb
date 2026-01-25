module GTD
  module Action
    module LabelCommands
      def list_labels
        system('todoist', 'labels') ? 0 : 1
      end

      def add_label(options)
        raise ArgumentError, '--name required for label-add command' unless options[:name]

        name = options[:name].sub(/^@/, '')
        payload = { name: name }

        response = @api.post('labels', payload)
        sync_todoist

        if response && response['id']
          puts "Created label: #{response['id']} @#{name}"
        end
        0
      end

      def update_label(options)
        raise ArgumentError, '--id required for label-update command' unless options[:id]
        raise ArgumentError, '--name required for label-update command' unless options[:name]

        name = options[:name].sub(/^@/, '')
        payload = { name: name }

        @api.post("labels/#{options[:id]}", payload)
        sync_todoist
        puts "Updated label: #{options[:id]} @#{name}"
        0
      end

      def delete_label(options)
        raise ArgumentError, '--id required for label-delete command' unless options[:id]

        deleted_id = options[:id]
        @api.delete("labels/#{options[:id]}")
        sync_todoist
        puts "Deleted label: #{deleted_id}"
        0
      end

      private

      def sync_todoist
        system('todoist', 'sync')
      end
    end
  end
end
