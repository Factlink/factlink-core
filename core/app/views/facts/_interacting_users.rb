module Facts
  class InteractingUsers < Mustache::Railstache
    def init
      self[:user_count] ||= 3
    end

    def activity
      a = last_activity().map { |a|
        { user: Users::User.for(user: a.user.user, view: self.view),
          id: a.id,
          action: internationalize_action(a.action)}
      }
      a
    end

    private
      def last_activity()
        self[:fact].interactions.below('inf',limit: self[:user_count]*3).uniq {|a| a.user_id}.take(self[:user_count])
      end

      def internationalize_action action
        case action.to_sym
        when :doubts
          t(:fact_doubt_past_action).titleize
        when :believes
          t(:fact_believe_past_action).titleize
        when :disbelieves
          t(:fact_disbelieve_past_action).titleize
        when :created
          t(:fact_create_past_action).titleize
        else
          #TODO internationalize activities properly
          action.titleize
        end
      end
  end
end
