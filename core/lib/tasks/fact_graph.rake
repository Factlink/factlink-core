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
        run_once_per_minutes = 60
        puts "now recalculating with interval of #{run_once_per_minutes} minutes"
        $stdout.flush
        while true
          start_time = Time.now
          puts "now recalculating factgraph"
          $stdout.flush
          FactGraph.recalculate

          after_interval_time = start_time + 60*run_once_per_minutes
          sleep_for = after_interval_time - Time.now
          sleep sleep_for if sleep_for > 0
        end
      end
    ensure
      File.delete ENV['PIDFILE'] if ENV['PIDFILE']
    end
  end
end
