# coding: utf-8

module Acceptance
  module ConversationHelper
    def send_reply(reply_str)
      within(:css, "div.message-reply") do
        fill_in "reply", with: reply_str

        click_on "Send message"
      end

      page.find('.message-text', text: reply_str)
    end

    def last_message_should_have_content(reply_str)
      within(:css, "div.messages li:last-child") do
        page.should have_content reply_str
      end
    end

    def send_message(message, factlink, recipients)
      visit friendly_fact_path(factlink)

      within '.top-fact' do
        click_on "Share"
      end

      within '.start-conversation' do
        recipients.each {|r| add_recipient r.name}
        find(:css, 'textarea').click
        sleep 0.1
        find(:css, 'textarea').set(message)

        click_button 'Send'
      end

      page.should have_content 'Your message has been sent!'
    end

    def add_recipient name
      page.find(:css, 'input[type=text]').set(name)

      within('.auto-complete-search-list') do
        el = page.find('li .text em', text: name)
        el.click
      end

      page.find('.auto-complete-results-container', text: name)
    end

    def page_should_have_factlink_and_message(message, factlink, recipient)
      page.should have_content factlink.data.displaystring

      within '.conversation .messages' do
        page.should have_content message
        page.should have_content @user.name
        page.should_not have_content recipient.name if recipient
      end
    end

    def open_message_with_content(message_str)
      find(".conversations-link").click

      within '.conversations-overview-item' do
        page.should have_content(message_str)
      end

      find(:css, "div.conversation-text", text: message_str).click

      page.should have_selector '.conversation .fact-view'
    end
  end
end
