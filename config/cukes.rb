class Cukes
  require 'active_support/configurable'
  include ActiveSupport::Configurable

  self.configure do |config|
    config.root = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
    config.rails_root = File.join(config.root, "backend")
    config.ember_root = File.join(config.root, "frontend")
    config.host = "http://localhost:4200"
    config.browser = ENV["BROWSER"] || :phantomjs
    config.startup_timeout = 45
  end

end
