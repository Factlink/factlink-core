require 'integration_helper'

describe "conversation", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @recipients = [FactoryGirl.create(:approved_confirmed_user), FactoryGirl.create(:approved_confirmed_user)]

    enable_features @user, :messaging
    @recipients.each {|r| enable_features r, :messaging}
  end

  it "message can be sent and viewed" do
    factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    recipient_ids = Message.last.conversation.recipients.map {|r| r.id}

    @recipients.each do |recipient|
      expect(recipient_ids).to include recipient.id
      switch_to_user recipient
      open_message_with_content message_content
      page_should_have_factlink_and_message(message_content, factlink, recipient)
    end
  end

  it "a user should be able to reply to a message" do
    factlink = FactoryGirl.create(:fact, created_by: @user.graph_user)
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    recipient_ids = Message.last.conversation.recipients.map {|r| r.id}

    @recipients.each do |recipient|
      expect(recipient_ids).to include recipient.id

      switch_to_user @user
      open_message_with_content message_content
      page_should_have_factlink_and_message(message_content, factlink, nil)
      last_message_should_have_content(message_content)

      message_content = FactoryGirl.generate(:content)
      send_reply(message_content)
      last_message_should_have_content(message_content)
    end
  end

  def send_reply(reply_str)
    within(:css, "div.reply") do
      fill_in "reply", with: reply_str

      click_on "Send message"
    end
    wait_for_ajax
  end

  def last_message_should_have_content(reply_str)
    within(:css, "div.messages li:last-child") do
      page.should have_content reply_str
    end
  end

  def send_message(message, factlink, recipients)
    visit friendly_fact_path(factlink)

    click_on "Share"

    wait_until_scope_exists '.start-conversation-form' do
      recipients.each {|r| add_recipient r.username}
      find(:css, '.text').set(message)

      click_button 'Send'
      wait_for_ajax
    end
  end

  def add_recipient name
    page.find(:css, 'input').set(name)
    wait_for_ajax
    page.find('li', text: name).click
    page.find('.auto-complete-results-container li', text: name)
  end

  def page_should_have_factlink_and_message(message, factlink, recipient)
    page.should have_content factlink.data.displaystring

    wait_until_scope_exists '.conversation .messages' do
      page.should have_content message
      page.should have_content @user.username
      page.should_not have_content recipient.username if recipient
    end
  end

  def open_message_with_content(message_str)
    click_link "conversations-link"

    sleep 2

    wait_until_scope_exists '.conversations li' do
      page.should have_content(message_str)
    end

    find(:css, "div.text", text: message_str).click

    wait_until_scope_exists '.conversation .fact-view'
  end
end
