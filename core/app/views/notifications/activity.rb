module Notifications
  class Activity < Mustache::Railstache

    # TODO: This should have the real indication wheter the activity is read
    # or unread
    def unread
      self[:activity].created_at.to_i > current_user.last_read_activities_on.to_i ? true : false
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

      case self[:activity].action

      # Channel activity
      when "added_subchannel"
        return Activities::AddedSubchannel.for(activity: self[:activity], view: self[:view])

      # Opinion activity
      when "believes", "doubts", "disbelieves"
        return Notifications::Opinionated.for(activity: self[:activity], view: self[:view])

      # Evidence activities
      when "added_supporting_evidence", "added_weakening_evidence"
        return Notifications::AddedEvidence.for(activity: self[:activity], view: self[:view])
      else
        return self[:activity]
      end
    end
  end
end