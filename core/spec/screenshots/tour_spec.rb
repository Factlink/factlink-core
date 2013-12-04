require 'screenshot_helper'

describe "Check the tour", type: :feature do
  include PavlovSupport

  before do
    user = create(:full_user)
    sign_in_user(user)
  end

  it 'Extension page should be the same' do
    visit install_extension_path

    assume_unchanged_screenshot 'extension'
  end

  it 'Create your first factlink page should be the same' do
    visit create_your_first_factlink_path

    assume_unchanged_screenshot 'create_your_first_factlink'
  end

  it 'Interests page should be the same' do
    user = create :user
    Pavlov.command(:'users/add_handpicked_user', user_id: user.id.to_s)

    as(user) do |pavlov|
      channel1 = pavlov.command(:'channels/create', title: 'toy')
      channel2 = pavlov.command(:'channels/create', title: 'story')

      factlink = create :fact, created_by: user.graph_user

      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: channel1)
      pavlov.interactor(:'channels/add_fact', fact: factlink, channel: channel2)
    end

    visit interests_path

    assume_unchanged_screenshot 'interests'
  end
end
