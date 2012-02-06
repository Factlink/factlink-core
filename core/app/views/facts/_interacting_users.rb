module Facts
  class InteractingUsers < Mustache::Railstache

    def activity
      a = last_activity().map { |a|
        { user: Users::User.for(user: a.user.user, view: self.view),
          id: a.id,
          action: internationalize_action(a.action)}
      }
      a
    end

    private
      def last_activity(nr=3)
        # TODO inefficient implementation, we can speed this up by doing more manually
        Activity::For.fact(self[:fact]).sort(limit: 3*3, order: 'DESC').uniq {|a| a.user_id}.take(3)
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
