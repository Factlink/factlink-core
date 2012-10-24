require 'integration_helper'

describe "conversation", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @recipient = FactoryGirl.create :approved_confirmed_user

    enable_features @user, :messaging
  end

  it "message can be sent" do
    @factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    click_on "Send message"

    wait_until_scope_exists '.start-conversation-form' do

      message = 'content'

      find(:css, '.recipients').set(@user.username)
      find(:css, '.text').set(message)

      click_button 'Send'
    end


  end
end
