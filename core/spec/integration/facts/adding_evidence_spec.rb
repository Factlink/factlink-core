require 'integration_helper'

feature "adding evidence to a fact", type: :request do
  include Acceptance

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user}

  let :discussion_page do
    Acceptance::DiscussionPage.new self, factlink.id
  end

  scenario "initially the evidence list should be empty" do
    pending
    discussion_page.goto

    expect(discussion_page.supporting_evidence.nr).to eq 0
  end

  scenario "after adding a piece of evidence evidence list should contain that item" do
    pending
    discussion_page.goto

    discussion_page.supporting_evidence.add_new "Gerrit"

    screen_shot_and_open_image
    expect(discussion_page.supporting_evidence.nr).to eq 1
  end

end
