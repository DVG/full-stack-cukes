require 'factory_girl'
require 'debugger'
require 'active_record'
require 'childprocess'

CukesRoot = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
RailsRoot = File.join(CukesRoot, "backend")
EmberRoot = File.join(CukesRoot, "frontend")

# Require Models
Dir["#{RailsRoot}/models/**/*.rb"].each { |f| require f }

# Require Factories
Dir["#{RailsRoot}/spec/factories/*.rb"].each { |f| require f }

# Connect to Test Database, suggest simply symlinking your actual database.yml from backend to config/database.yml in this project
database_yml = File.expand_path('../../../config/database.yml', __FILE__)
if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)
  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations['test']
  ActiveRecord::Base.establish_connection(config)
else
  raise "Please create #{database_yml} first to configure your test database"
end

require_relative './application_manager'
manager = ApplicationManager.new
manager.start_stack
at_exit do
  manager.stop_stack
end
