require 'acceptance_helper'

describe "creating a Factlink", type: :request do
  include Acceptance::ProfileHelper
  include Acceptance::AddToChannelModalHelper
  include Acceptance::NavigationHelper

  def created_channel_path(user)
    channel_path(user.username, user.graph_user.created_facts_channel.id)
  end

  before :each do
    @user = sign_in_user create :active_user
  end

  it "should add a factlink" do
    fact_name = "baronnenbillen"

    visit new_fact_path(fact: fact_name)

    click_button "Post to Factlink"

    go_to_profile_page_of @user

    page.should have_content "Feed"
    page.should have_content fact_name
  end

  it "should add a factlink to a topic" do
    fact_name = "baronnenbillen"
    new_topic_name = 'Gerrit'

    visit new_fact_path(fact: fact_name)

    add_as_new_channel new_topic_name
    click_button "Post to Factlink"

    wait_for_ajax

    visit fact_path(Fact.last.id)

    open_modal 'Repost' do
      added_channels_should_contain new_topic_name
    end

    visit current_path
    open_modal 'Repost' do
      added_channels_should_contain new_topic_name
    end
  end

  it "should be able to delete a factlink" do
    fact_name = "raar"

    # create fact:
    visit new_fact_path(fact: fact_name)

    click_button "Post to Factlink"

    go_to_profile_page_of @user

    page.should have_content fact_name

    # and delete it:
    page.evaluate_script('window.confirm = function() { return true; }')

    page.find(:css, ".top-right-arrow").click

    page.find(:css, "li.delete").click

    page.should_not have_content fact_name
  end
end
