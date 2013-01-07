module Util
  module Mixpanel
    def track_event *args
      @options[:mixpanel].track_event *args
    end

    def increment_person_event event
      current_user_id = @options[:current_user].id.to_s
      @options[:mixpanel].increment_person_event current_user_id, {event => 1}
    end
  end
end
