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

api = ChildProcess.build("rails", "s", "-e", "test")
api_log = api.io.stdout = Tempfile.new('api-log')
api.cwd =  RailsRoot
front_end = ChildProcess.build("ember", "serve", "--proxy", "http://localhost:3000")
front_end_log = front_end.io.stdout = Tempfile.new('front-end-log')
front_end.cwd = EmberRoot


api.start
front_end.start
# Let the processes start up
begin
  Timeout.timeout(15) do # Depending on your Project Size and how long booting your server takes, you may adjust this timeout
    processes_started = false
    while !processes_started
      sleep 1
      if open(api_log).read.include?("WEBrick::HTTPServer#start: pid=") && open(front_end_log).read.include?("Build successful")
        processes_started = true
      end
    end
  end
rescue Timeout::Error => e
  api.stop
  front_end.stop
  until api.exited? && front_end.exited?
    sleep 1
  end
end


at_exit do
end
