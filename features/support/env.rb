require 'factory_girl'
require 'active_record'
require 'childprocess'
require 'database_cleaner'
require 'active_support/dependencies'
require 'page-object'
require 'page-object/page_factory'

require_relative './application_manager'

CukesRoot = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
RailsRoot = File.join(CukesRoot, "backend")
EmberRoot = File.join(CukesRoot, "frontend")

# Require Models
ActiveSupport::Dependencies.autoload_paths += Dir.glob File.join(RailsRoot, "app/models")

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

# Application Manager will start up the rails and ember apps before the suite is run and shut them down when we're finished
manager = ApplicationManager.new
manager.start_stack
at_exit do
  manager.stop_stack
end


# Database Cleaner to clear out the test DB between tests
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation
Around do |scenario, block|
    DatabaseCleaner.cleaning(&block)
end

# Page Object Stuff
PageObject.javascript_framework = :jquery # Ember uses Jquery Under the hood
World(PageObject::PageFactory)
AppHost = "http://localhost:4200"
