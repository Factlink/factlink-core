module Facts
  class InteractingUsers < Mustache::Railstache

    def activity
      a = last_activity().map { |a|
        { user: Users::User.for(user: a.user.user, view: self.view),
          id: a.id,
          action: a.action}
      }
      a
    end

    private
      def last_activity(nr=3)
        # TODO inefficient implementation, we can speed this up by doing more manually
        Activity::For.fact(self[:fact]).sort(limit: 3*3, order: 'DESC').uniq {|a| a.user_id}.take(3)
      end
  end
end
