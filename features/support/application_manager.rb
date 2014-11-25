module ChildProcess
  module Unix
    class Process < AbstractProcess
      def interrupt
        send_signal "SIGINT"
      end
    end
  end
end

class ApplicationManager
  require 'childprocess'

  @@processes_started = false
  attr_accessor :rails, :ember, :rails_log, :ember_log

  def initialize
    @rails = ChildProcess.build("sh", "-c", "BUNDLE_GEMFILE=Gemfile bundle exec rails s")
    @rails.leader = true
    @rails.cwd = RailsRoot
    @rails_log = @rails.io.stdout = @rails.io.stderr = Tempfile.new('rails-log')

    @ember = ChildProcess.build("ember", "serve", "--proxy", "http://localhost:3000")
    @ember.leader = true
    @ember.cwd = EmberRoot
    @ember_log = @ember.io.stdout = @ember.io.stderr = Tempfile.new("ember-log")
  end

  def start_stack
    puts "Bringing the Applications Online, sit tight"
    rails.start
    ember.start
    wait_for_processes_started
    puts "Applications Online"
  end

  def stop_stack
    rails.interrupt
    ember.interrupt
    wait_for_processes_to_exit
  end


private

  def wait_for_processes_started
    begin
      Timeout::timeout(15) do # Depending on your Project Size and how long booting your server takes, you may adjust this timeout
        loop do
           break if processes_started?
        end
      end
    rescue Timeout::Error => e
      rails.interrupt
      ember.interrupt
      wait_for_processes_to_exit
      raise "Unable to start the application"
    end
  end

  def wait_for_processes_to_exit
    begin 
      Timeout::timeout(5) do
        loop { break if rails.exited? && ember.exited? }
      end
    rescue Errno::ESRCH => e
      # Already stopped the process, no biggie
    rescue Timeout::Error => e
      raise "Unable to exit processes. pids: #{rails.pid}, #{ember.pid}"
    end
  end

  def processes_started?
    open(rails_log).read.include?("WEBrick::HTTPServer#start: pid=") && open(ember_log).read.include?("Build successful")
  end
end
