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
    @user1 = create :user
    Pavlov.command(:'users/add_handpicked_user', user_id: @user1.id.to_s)

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.command(:'channels/create', title: 'toy')
      @user1_channel2 = pavlov.command(:'channels/create', title: 'story')
    end

    visit interests_path

    assume_unchanged_screenshot 'interests'
  end
end
