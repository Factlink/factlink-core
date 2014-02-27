class Believable
  attr_reader :key
  def initialize key
    @key = key
  end

  def votes
    {
      believes: opiniated(:believes).count,
      disbelieves: opiniated(:disbelieves).count,
      doubts: opiniated(:doubts).count
    }
  end

  def opinion_of_graph_user graph_user
    OpinionType.types.each do |opinion|
      return opinion if opiniated(opinion).include? graph_user
    end
    return :no_vote
  end

  def opinionated_users_ids
    (opiniated(:believes) | opiniated(:doubts) | opiniated(:disbelieves)).ids
  end

  def opiniated(type)
    fail 'Unknown opinion type' unless OpinionType.include?(type.to_s)

    graph_user_set "people_#{type.to_s}"
  end

  def add_opiniated(type, graph_user)
    remove_opinionateds graph_user
    opiniated(type).add(graph_user)
  end

  def remove_opinionateds(graph_user)
    OpinionType.types.each do |type|
      opiniated(type).delete(graph_user)
    end
  end

  def delete
    opiniated(:believes).clear
    opiniated(:disbelieves).clear
    opiniated(:doubts).clear
  end

  private

  def graph_user_set name
    Ohm::Model::Set.new(@key[name],Ohm::Model::Wrapper.wrap(GraphUser))
  end
end
