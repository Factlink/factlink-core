class LoadDsl
  FactDsl = Struct.new(:fact) do
    def believers(*l)
      set_opinion(:believes, *l)
    end

    def disbelievers(*l)
      set_opinion(:disbelieves, *l)
    end

    def doubters(*l)
      set_opinion(:doubts, *l)
    end

    def set_opinion(opinion_type, *users)
      users.each do |username|
        gu = User.where(username: username).first.graph_user
        fact.add_opinion opinion_type, gu
      end
    end
  end
end
