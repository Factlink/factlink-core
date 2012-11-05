class Activity < OurOhm
  module Subject

    def self.activity(graph_user, action, subject, sub_action = :to ,object = nil)
      Activity.create(user: graph_user,action: action, subject: subject, object: object)
    end

    def activity *args
      Activity::Subject.activity(*args)
    end

  end
end
