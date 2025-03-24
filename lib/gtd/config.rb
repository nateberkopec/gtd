require 'dotenv'

module GTD
  module Config
    # Load environment variables from .env file
    Dotenv.load

    # Todoist API token
    def self.todoist_api_token
      ENV['TODOIST_API_TOKEN'] || raise("TODOIST_API_TOKEN not set in environment variables")
    end

    # Todoist API URL
    def self.todoist_api_url
      'https://api.todoist.com/rest/v2'
    end

    # OpenAI API token
    def self.openai_api_key
      ENV['OPENAI_API_KEY'] || raise("OPENAI_API_KEY not set in environment variables")
    end

    # OpenAI model to use
    def self.openai_model
      ENV['OPENAI_MODEL'] || 'gpt-4'
    end
  end
end
