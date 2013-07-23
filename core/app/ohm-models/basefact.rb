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

  def insert_or_update_opinion(type, new_opinion)
    original_opinion = send(type)
    if original_opinion
      original_opinion.take_values new_opinion
    else
      send "#{type}=", new_opinion.save
      save
    end
  end
end
