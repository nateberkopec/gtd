module GTD
  module Config

    # Todoist API token
    def self.todoist_api_token
      ENV['TODOIST_API_TOKEN'] || raise("TODOIST_API_TOKEN not set in environment variables")
    end

    # Todoist API URL
    def self.todoist_api_url
      'https://api.todoist.com/rest/v2'
    end
  end
end
