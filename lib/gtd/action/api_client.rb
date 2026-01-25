require 'json'
require 'net/http'
require 'uri'

module GTD
  module Action
    class ApiClient
      class ApiError < StandardError; end

      attr_writer :config_path

      def initialize
        @config_path = File.expand_path('~/.config/todoist/config.json')
        @token = load_token
      end

      def get(path)
        request(:get, path)
      end

      def post(path, payload = nil)
        request(:post, path, payload)
      end

      def delete(path)
        request(:delete, path)
      end

      def lookup_project_id(name)
        projects = get('projects')
        project = projects.find { |p| p['name'] == name }
        project&.dig('id')
      end

      def lookup_section_id(project_name, section_name)
        proj_id = lookup_project_id(project_name)
        return nil unless proj_id

        sections = get("sections?project_id=#{proj_id}")
        section = sections.find { |s| s['name'] == section_name }
        section&.dig('id')
      end

      def sync_command(uuid, cmd_type, args)
        cmd_json = {
          type: cmd_type,
          uuid: uuid,
          args: args
        }.to_json

        uri = URI('https://api.todoist.com/sync/v9/sync')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(uri)
        req['Authorization'] = "Bearer #{@token}"
        req.set_form_data('commands' => "[#{cmd_json}]")

        response = http.request(req)
        raise ApiError, "Sync command failed: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        result = JSON.parse(response.body)
        raise ApiError, "Sync command failed: #{result.inspect}" unless result['sync_status']&.all? { |s| s == 'ok' }

        result
      end

      def task_url(id)
        "https://todoist.com/showTask?id=#{id}"
      end

      def project_url(id)
        "https://todoist.com/showProject?id=#{id}"
      end

      private

      def load_token
        config = JSON.parse(File.read(@config_path))
        config['token']
      rescue Errno::ENOENT, JSON::ParserError => e
        raise ApiError, "Failed to load Todoist token from #{@config_path}: #{e.message}"
      end

      def request(method, path, payload = nil)
        url = "https://api.todoist.com/rest/v2/#{path}"
        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = case method
        when :get then Net::HTTP::Get.new(uri)
        when :post then Net::HTTP::Post.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end

        req['Authorization'] = "Bearer #{@token}"

        if payload
          req['Content-Type'] = 'application/json'
          req.body = payload.to_json
        end

        response = http.request(req)
        raise ApiError, "API request failed: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body) if response.body && !response.body.empty?
      end
    end
  end
end
