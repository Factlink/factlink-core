class LoadDsl
  FactDsl = Struct.new(:fact) do
    def believers(*l)
      set_opinion(:believes, *l)
    end

    def disbelievers(*l)
      set_opinion(:disbelieves, *l)
    end

    def comment(username, comment)

      u = User.where(username: username).first

      pavlov_options = { current_user: u }

      Pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, content: comment, pavlov_options: pavlov_options)
    end

    def set_opinion(opinion_type, *users)
      users.each do |username|
        gu = User.where(username: username).first.graph_user || fail("user not found " + username)
        fact.add_opinion opinion_type, gu
      end
    end
  end
end
