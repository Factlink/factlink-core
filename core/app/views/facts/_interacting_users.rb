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
        Activity::For.fact(self[:fact]).sort_by(:created_at, limit: nr, order: "ALPHA DESC").reverse
      end
  end
end
