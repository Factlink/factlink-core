class Believable
  attr_reader :key
  def initialize key
    @key = key
  end

  def dead_opinion
    believes_count = people_believes.count
    disbelieves_count = people_disbelieves.count
    doubts_count = people_doubts.count
    authority = believes_count + disbelieves_count + doubts_count

    return DeadOpinion.zero if authority.zero?

    DeadOpinion.new(believes_count.to_f/authority.to_f, disbelieves_count.to_f/authority.to_f,
                    doubts_count.to_f/authority.to_f, authority.to_f)
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

  # the following three functions should be considered
  # private
  def people_believes
    graph_user_set 'people_believes'
  end

  def people_disbelieves
    graph_user_set 'people_disbelieves'
  end

  def people_doubts
    graph_user_set 'people_doubts'
  end
  # /private

  def opinionated_users_ids
    (people_believes | people_doubts | people_disbelieves).ids
  end

  def opiniated(type)
    send(:"people_#{OpinionType.real_for(type)}")
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
  def graph_user_set name
    Ohm::Model::Set.new(@key[name],Ohm::Model::Wrapper.wrap(GraphUser))
  end
end
