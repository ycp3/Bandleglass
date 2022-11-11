# Load the Rails application.
require_relative "application"

env_file = File.join(Rails.root, "config", "env.rb")
load(env_file) if File.exist?(env_file)

# Initialize the Rails application.
Rails.application.initialize!
