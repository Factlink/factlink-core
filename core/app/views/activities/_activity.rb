module Activities
  class Activity < Mustache::Railstache


    def action
      self[:activity].action
    end

    def activity

      case self[:activity].action
      when "added_subchannel"
        return Activities::AddedSubchannel.for(activity: self[:activity], view: self[:view])

      else
        puts "Default activity"
      end
    end
  end
end