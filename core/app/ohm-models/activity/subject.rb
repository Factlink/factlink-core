class Activity < OurOhm
  module Subject

    def activity(graph_user, action, subject, sub_action = :to ,object = nil)
      Activity.create(user: graph_user,action: action, subject: subject, object: object)
    end

    def activities(nr=nil)
      Activity.for(self).sort_by(:created_at, order: "DESC ALPHA", limit: nr)
    end

  end
end