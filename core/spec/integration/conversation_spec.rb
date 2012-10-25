require 'integration_helper'

describe "conversation", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @recipient = FactoryGirl.create :approved_confirmed_user

    enable_features @user, :messaging
    enable_features @recipient, :messaging
  end

  it "message can be sent" do
    @factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    message_str = 'content'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    click_on "Send message"

    wait_until_scope_exists '.start-conversation-form' do
      find(:css, '.recipients').set(@recipient.username)
      find(:css, '.text').set(message_str)

      click_button 'Send'

      wait_for_ajax
    end

    sign_out_user @user

    sign_in_user @recipient

    click_link "conversations-link"

    wait_until_scope_exists '.conversations li' do
      page.should have_content(message_str)
    end

    find(:css, "div.text", text: message_str).click

    wait_until_scope_exists '.conversation .fact' do
      page.should have_content @factlink.data.displaystring
    end

    wait_until_scope_exists '.conversation .messages' do
      page.should have_content message_str
      page.should have_content @user.username
      page.should_not have_content @recipient.username
    end
  end
end
