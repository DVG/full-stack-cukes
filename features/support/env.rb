require 'factory_girl'

RailsRoot = Dir[File.dirname(__FILE__) + '../../backend']

# Require Models
Dir["#{RailsRoot}/models/**/*.rb"].each { |f| require f }

# Require Factories
Dir["#{RailsRoot}/spec/factorties/*.rb"].each { |f| require f }

