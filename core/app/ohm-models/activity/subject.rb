class Activity < OurOhm
  module Subject

    def self.activity(graph_user, action, subject, object = nil)
      Activity.create(user: graph_user,action: action, subject: subject, object: object)
    end

  end
end
