module Activities
  class Activity < Mustache::Railstache

    def username
      self[:activity].user.user.username
    end

    def user_profile_url
      user_profile_path(self[:activity].user.user)
    end

    def avatar(size=32)
      image_tag(self[:activity].user.user.avatar_url(size: size), :width => size)
    end

    def action
      self[:activity].action
    end

    def subject
      self[:activity].subject.to_s
    end

    def icon
      image_tag('activities/icon-generic.png')
    end

    def time_ago
      "#{time_ago_in_words(self[:activity].created_at)} ago"
    end

    def activity
      case self[:activity].action
      when "added_subchannel"
        return Activities::AddedSubchannel.for(activity: self[:activity], view: self[:view])

      when "added_supporting_evidence"
        return Activities::AddedEvidence.for(activity: self[:activity], view: self[:view])

      when "added_weakening_evidence"
        return Activities::AddedEvidence.for(activity: self[:activity], view: self[:view])

      else
        return self
      end
    end
  end
end