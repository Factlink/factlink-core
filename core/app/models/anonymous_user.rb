class AnonymousUser
  class AnonymousGraphUser
    def opinion_on fact
      nil
    end
  end

  def graph_user
    AnonymousGraphUser.new
  end
end
