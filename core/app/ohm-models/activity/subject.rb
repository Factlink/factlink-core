class Activity < OurOhm
  module Subject

    def activity(graph_user, action, subject, sub_action = :to ,object = nil)
      Activity.create(user: graph_user,action: action, subject: subject, object: object)
    end

  end
end