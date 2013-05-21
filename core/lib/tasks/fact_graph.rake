namespace :fact_graph do
  def exception_notify
    yield
  rescue SignalException => exception
    # we were killed (probably by deploy)
  rescue Exception => exception
    if defined?(ExceptionNotifier)
      ExceptionNotifier::Notifier.background_exception_notification(exception)
    end
    raise exception
  end

  task :recalculate => :environment do
    # Legacy code, not sure if other scripts still depend on this
    if Rails.env != 'development'
      `echo "#{Process.pid}" > /var/lock/monit/fact_graph/fact_graph_recalculate.pid`
      `echo "#{Process.ppid}" > /var/lock/monit/fact_graph/fact_graph_recalculate.ppid`
    end

    # New way of writing to a pidfile
    File.open(ENV['PIDFILE'], 'w') {|f| f.puts Process.pid} if ENV['PIDFILE']

    begin
      exception_notify do
        STDOUT.flush
        sleep_time = 59
        puts "now recalculating with interval of #{sleep_time} seconds"
        $stdout.flush
        while true
          puts "now recalculating factgraph"
          $stdout.flush
          FactGraph.recalculate
          sleep sleep_time
        end
      end
    ensure
      File.delete ENV['PIDFILE'] if ENV['PIDFILE']
    end
  end
end
