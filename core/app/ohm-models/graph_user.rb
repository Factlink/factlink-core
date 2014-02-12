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
end
