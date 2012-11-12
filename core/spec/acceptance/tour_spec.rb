require 'integration_helper'

describe "Check the tour", type: :request do

  before do
    @user = make_non_tos_user_and_login

    fill_in "user_tos_first_name", with: "Sko"
    fill_in "user_tos_last_name", with: "Brenden"
    check "user_agrees_tos"

    click_button "Next"
  end

  it 'You''re almost set page should be the same' do

    assume_unchanged_screenshot 'extension'
  end

  it 'Let''s create your first factlink page should be the same' do
    click_link "Skip this step"

    sleep 10

    assume_unchanged_screenshot 'create_your_first_factlink'
  end
end
