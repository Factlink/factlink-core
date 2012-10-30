module Pavlov
  module Mixpanel
    def track_event *args
      @options[:mixpanel].track_event *args
    end
  end
end
