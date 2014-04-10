class LoadDsl
  FactDsl = Struct.new(:dead_fact) do
    def believers(*l)
      set_opinion(:believes, *l)
    end

    def disbelievers(*l)
      set_opinion(:disbelieves, *l)
    end

    def comment(username, comment)
      user = User.where(username: username).first

      pavlov_options = {current_user: user, time: Time.now}

      Pavlov.interactor(:'comments/create', fact_id: dead_fact.id, content: comment, pavlov_options: pavlov_options)
    end

    def set_opinion(opinion_type, *users)
      users.each do |username|
        user = User.where(username: username).first || fail("user not found " + username)

        pavlov_options = {current_user: user, time: Time.now}

        Pavlov.interactor(:'facts/set_opinion', fact_id: dead_fact.id, opinion: opinion_type.to_s, pavlov_options: pavlov_options)
      end
    end
  end
end
