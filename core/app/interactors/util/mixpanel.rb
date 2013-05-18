module Util
  module Mixpanel

    def track(event, opts={})
      current_user = @options[:current_user]
      if current_user
        opts = opts.update(
          mp_name_tag: current_user.username,
          distinct_id: current_user.id,
          time: Time.now.utc.to_i
        )
      end

      Resque.enqueue(::Mixpanel::TrackEventJob, event, opts, {})
    end

    def track_event *args
      @options[:mixpanel].track_event *args
    end

    def increment_person_event event
      current_user_id = @options[:current_user].id.to_s
      @options[:mixpanel].increment_person_event current_user_id, {event => 1}
    end
  end
end
