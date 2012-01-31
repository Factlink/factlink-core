module Activities
  class Activity < Mustache::Railstache

    def action
      self[:activity].action
    end

    def time_ago
      "#{time_ago_in_words(self[:activity].created_at)} ago"
    end

    def activity

      case self[:activity].action
      when "added_subchannel"
        return Activities::AddedSubchannel.for(activity: self[:activity], view: self[:view])

      else
        puts "Default activity"
        return Activities::Generic.for(activity: self[:activity], view: self[:view])
      end
    end
  end
end