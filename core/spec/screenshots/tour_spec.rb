require 'screenshot_helper'

describe "Check the tour", type: :request do
  include PavlovSupport

  before do
    user = create(:active_user)
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
    Pavlov.old_command :"users/add_handpicked_user", @user1.id.to_s

    as(@user1) do |pavlov|
      @user1_channel1 = pavlov.old_command :'channels/create', 'toy'
      pavlov.old_command :'topics/update_user_authority', @user1.graph_user_id.to_s, @user1_channel1.slug_title, 0
      @user1_channel2 = pavlov.old_command :'channels/create', 'story'
      pavlov.old_command :'topics/update_user_authority', @user1.graph_user_id.to_s, @user1_channel2.slug_title, 3
    end

    visit interests_path

    assume_unchanged_screenshot 'interests'
  end

  it 'Feed should be the same' do
    @user1 = create :user

    visit activities_path(@user1)

    assume_unchanged_screenshot 'feed'
  end
end
