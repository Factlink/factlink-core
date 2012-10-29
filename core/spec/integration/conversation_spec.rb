require 'integration_helper'

describe "conversation", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @recipient = FactoryGirl.create :approved_confirmed_user

    enable_features @user, :messaging
    enable_features @recipient, :messaging
  end

  it "message can be sent and viewed" do
    @factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    message_str = 'content'

    send_message_and_view_as_recipient(message_str, @factlink, @recipient)
  end

  it "a user should be able to reply to a message" do
    @factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    message_str = 'content'
    reply_str = "Bazenbeer"

    send_message_and_view_as_recipient(message_str, @factlink, @recipient)

    within(:css, "div.reply") do
      fill_in "reply", with: reply_str

      click_on "Send message"
    end

    wait_for_ajax

    within(:css, "div.messages li:last-child") do
      page.should have_content reply_str
    end
  end
end

def send_message_and_view_as_recipient(message, factlink, recipient)
  visit friendly_fact_path(factlink)

  click_on "Send message"

  wait_until_scope_exists '.start-conversation-form' do
    find(:css, '.recipients').set(recipient.username)
    find(:css, '.text').set(message)

    click_button 'Send'

    wait_for_ajax
  end

  sign_out_user @user

  sign_in_user @recipient

  click_link "conversations-link"

  wait_until_scope_exists '.conversations li' do
    page.should have_content(message)
  end

  find(:css, "div.text", text: message).click

  wait_until_scope_exists '.conversation .fact' do
    page.should have_content @factlink.data.displaystring
  end

  wait_until_scope_exists '.conversation .messages' do
    page.should have_content message
    page.should have_content @user.username
    page.should_not have_content @recipient.username
  end
end
