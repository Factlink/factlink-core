module FeedHelper
  include PavlovSupport

  def create_default_activities_for user
    other_user = create :user

    as(user) do |p|
      p.interactor :'users/follow_user', username: other_user.username
    end

    fact_data = create :fact_data
    comment2 = nil
    as(user) do |p|
      comment2 = p.interactor :'comments/create', fact_id: fact_data.fact_id.to_s, content: 'hoi'
    end
    as(other_user) do |p|
      p.interactor :'sub_comments/create', comment_id: comment2.id.to_s, content: 'doei'
    end
    as(user) do |p|
      p.interactor :'sub_comments/create', comment_id: comment2.id.to_s, content: 'moi'
    end

    as(other_user) do |p|
      p.interactor :'comments/create', fact_id: fact_data.fact_id.to_s, content: 'hallo'
    end

    as(other_user) do |p|
      p.interactor :'users/follow_user', username: user.username
      p.interactor :'users/follow_user', username: (create :user).username
    end
  end
end
