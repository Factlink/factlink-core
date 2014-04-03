class GraphUser < OurOhm
  reference :user, ->(id) { id && User.find(id) }

  timestamped_set :notifications, Activity
  timestamped_set :stream_activities, Activity
  timestamped_set :own_activities, Activity
end
