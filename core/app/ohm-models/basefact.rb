class Basefact < OurOhm
  include Activity::Subject

  reference :created_by, GraphUser

  reference :user_opinion, Opinion

  def believable
    @believable ||= Believable.new(self.key)
  end

  def delete_believable
    believable.delete
  end
  before :delete, :delete_believable

  delegate :opinionated_users_ids, :opinionated_users_count, :opiniated, :add_opiniated, :remove_opinionateds,
           :people_believes, :people_doubts, :people_disbelieves,
         :to => :believable

  def validate
    assert_present :created_by
  end

  def add_opinion(type, user)
    add_opiniated(type,user)
  end

  def remove_opinions(user)
    remove_opinionateds(user)
  end

  # TODO: use separate redis stores instead of using references inside the models
  def insert_or_update_dead_opinion(opinion_name, new_dead_opinion)
    new_opinion = Opinion.new
    new_opinion.take_values new_dead_opinion
    insert_or_update_opinion opinion_name, new_opinion
  end

  def get_dead_opinion(opinion_name)
    DeadOpinion.from_opinion(send(opinion_name) || Opinion.zero)
  end

  private

  def insert_or_update_opinion(opinion_name, new_opinion)
    original_opinion = send(opinion_name)
    if original_opinion
      original_opinion.take_values new_opinion
    else
      new_opinion.save or raise "could not save opinion #{opinion_name}"
      send "#{opinion_name}=", new_opinion
      save
    end
  end
end
