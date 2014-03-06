require 'acceptance_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest
  include PavlovSupport

  let(:user) { create :user }
  let(:other_user) { create :user }

  before do
    # Keep in sync with controllers/api/feed_controller_spec
    as(user) do |p|
      p.interactor :'users/follow_user', username: other_user.username
    end

    fact = create :fact
    as(other_user) do |p|
      p.interactor :'comments/create', fact_id: fact.id.to_i, content: 'hoi'
    end

    fact2 = create :fact
    comment2 = nil
    as(user) do |p|
      comment2 = p.interactor :'comments/create', fact_id: fact2.id.to_i, content: 'hoi'
    end
    as(other_user) do |p|
      p.interactor :'sub_comments/create', comment_id: comment2.id.to_s, content: 'hoi'
    end

    as(other_user) do |p|
      p.interactor :'users/follow_user', username: (create :user).username
      p.interactor :'users/follow_user', username: (create :user).username
    end
  end

  it 'it renders 2 Factlinks' do
    sign_in_user(user)

    visit feed_path
    find('label[for=FeedChoice_Personal]').click
    find('.feed-activity:first-child')
    assume_unchanged_screenshot 'feed'
  end
end
