# coding: utf-8

require 'integration_helper'

module AddToChannelIntegrationTestHelper
  include FactHelper
  def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Add “#{name}” as a new channel"
      page.find('li', text: "Add “#{name}” as a new channel").click
      wait_for_ajax
  end

  def add_to_channel name
      type_into_search_box name
      page.should_not have_content "Add “#{name}” as a new channel"
      page.find('li', text: name).click
      wait_for_ajax
  end

  def go_to_discussion_page_of factlink
    path = friendly_fact_path factlink
    visit path
  end

  def open_modal tab_title, &block
    tablink = page.find_link(tab_title)
    tab_li = tablink.find(:xpath, '..')

    tab_class = tab_li['class'].split(/\s+/).first + '-container'

    puts "Tab class: '#{tab_class}'"

    click_link(tab_title)
    within(:css, ".#{tab_class} .modal-body") do
      yield
    end
  end

  def create_fact_in_backend
    create :fact, created_by: @user.graph_user
  end

  def create_channel_in_backend
    create :channel, created_by: @user.graph_user
  end

  def type_into_search_box value
    page.find(:css,'input').set(value)
  end

  def added_channels_should_contain name
    within(:css, ".auto-complete-results-container") do
      page.should have_content name
    end
  end
end


feature "adding a fact to a channel" do
  include AddToChannelIntegrationTestHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  scenario "adding a fact to a new channel from the factbubble" do
    @factlink = create_fact_in_backend

    go_to_discussion_page_of @factlink

    open_modal 'My Channels' do
      page.should have_content('Repost this to one or more channels:')

      add_as_new_channel 'Gerrit'
      added_channels_should_contain 'Gerrit'
    end
  end

  scenario "adding a fact to an existing channel from the factbubble" do
    @factlink = create_fact_in_backend
    @channel = create_channel_in_backend

    go_to_discussion_page_of @factlink

    open_modal 'My Channels' do
      add_to_channel @channel.title
      added_channels_should_contain @channel.title
    end
  end

end
