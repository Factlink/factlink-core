class Believable
  class Commentje < Believable
    def initialize id
      key = Ohm::Key.new("Comment:#{id}:believable")
      super key
    end

    # hide doubts
    def votes
      {
        believes: opiniated(:believes).count,
        disbelieves: opiniated(:disbelieves).count,
      }
    end

    def opinion_of_graph_user graph_user
      [:believes, :disbelieves].each do |opinion|
        return opinion if opiniated(opinion).include? graph_user
      end
      return :no_vote
    end
  end
end
