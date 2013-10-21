class GraphUser < OurOhm
  # small helper so we can write functions which
  # accept both users and graph_users
  # mostly legacy, but hard to debug whether we still need
  # this, so leaving for now.
  def graph_user
    self
  end

  # data
  reference :user, ->(id) { id && User.find(id) }

  timestamped_set :notifications, Activity
  timestamped_set :stream_activities, Activity

  collection :created_facts, Fact, :created_by
  timestamped_set :sorted_created_facts, Fact

  def opinion_on(fact)
    UserOpinion.new(self).on(fact)
  end
end
