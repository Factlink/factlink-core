require 'acceptance_helper'

describe "Check the tour", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest
  include PavlovSupport

  before do
    user = create(:full_user)
    sign_in_user(user)
  end

  it 'Extension page should be the same' do
    visit install_extension_path

    assume_unchanged_screenshot 'extension'
  end

  it 'Interests page should be the same' do
    user = create :user
    Pavlov.command(:'users/add_handpicked_user', user_id: user.id.to_s)
    create :fact, created_by: user.graph_user

    visit interests_path

    assume_unchanged_screenshot 'interests'
  end
end
