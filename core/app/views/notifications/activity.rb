module Notifications
  class Activity < Mustache::Railstache

    def unread
      self[:activity].created_at_as_datetime > current_user.last_read_activities_on
    end

    def username
      self[:activity].user.user.username
    end

    def user_profile_url
      channel_path(self[:activity].user.user,self[:activity].user.stream)
    end

    def avatar(size=20)
      image_tag(self[:activity].user.user.avatar_url(size: size), :width => size)
    end

    def icon
      image_tag('activities/icon-generic.png')
    end

    def time_ago
      "#{time_ago_in_words(self[:activity].created_at)} ago"
    end

    def action
      self[:activity].action
    end

    def activity
      opts = { activity: self[:activity], view: self[:view]}

      case opts[:activity].action

      when "added_subchannel"
        return Activities::AddedSubchannel.for(opts)

      when "believes", "doubts", "disbelieves"
        return Notifications::Opinionated.for(opts)

      when "added_supporting_evidence", "added_weakening_evidence"
        return Notifications::AddedEvidence.for(opts)

      when "created_channel"
        return Notifications::NewChannel.for(opts)

      when "added_fact_to_channel"
        return Notifications::AddedFactToChannel.for(opts)

      else
        return opts[:activity]
      end
    end
  end
end
