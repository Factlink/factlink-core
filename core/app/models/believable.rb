class Believable
  attr_reader :key
  def initialize key
    @key = key
  end

  def votes
    {
      believes: people_believes.count,
      disbelieves: people_disbelieves.count,
      doubts: people_doubts.count
    }
  end

  def opinion_of_graph_user graph_user
    OpinionType.types.each do |opinion|
      return opinion if opiniated(opinion).include? graph_user
    end
    return :no_vote
  end

  def opinionated_users_ids
    (people_believes | people_doubts | people_disbelieves).ids
  end

  def opiniated(type)
    fail 'Unknown opinion type' unless OpinionType.types.include?(type)

    send(:"people_#{type}")
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
    people_believes.clear
    people_disbelieves.clear
    people_doubts.clear
  end

  private

  def people_believes
    graph_user_set 'people_believes'
  end

  def people_disbelieves
    graph_user_set 'people_disbelieves'
  end

  def people_doubts
    graph_user_set 'people_doubts'
  end

  def graph_user_set name
    Ohm::Model::Set.new(@key[name],Ohm::Model::Wrapper.wrap(GraphUser))
  end
end
