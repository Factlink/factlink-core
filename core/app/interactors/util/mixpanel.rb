module Util
  module Mixpanel

    def mp_track(event, opts={})
      current_user = pavlov_options[:current_user]
      if current_user
        opts = opts.update(
          mp_name_tag: current_user.username,
          distinct_id: current_user.id,
          time: Time.now.utc.to_i
        )
      end

      Resque.enqueue(::Mixpanel::TrackEventJob, event, opts, {})
    end

    def mp_increment_person_property event
      return unless pavlov_options[:current_user]

      current_user_id = pavlov_options[:current_user].id.to_s
      opts = {event => 1}

      Resque.enqueue(::Mixpanel::TrackPeopleEventJob, current_user_id, opts, {})
    end
  end
end
