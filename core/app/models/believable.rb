class Believable
  def initialize key
    @key = key
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

  def opinionated_users_count
    people_believes.count + people_doubts.count + people_disbelieves.count
  end

  def opiniated(type)
    send(:"people_#{Opinion.real_for(type)}")
  end

  def add_opiniated(type, user)
    opiniated(type).add(user)
  end


  def remove_opinionateds(user)
    Opinion.types.each do |type|
      opiniated(type).delete(user)
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
