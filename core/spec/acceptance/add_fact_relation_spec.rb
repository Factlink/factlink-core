require 'acceptance_helper'

feature "adding factlinks to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  background do
    @user = sign_in_user create :full_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "initially the evidence list should be empty" do
    go_to_discussion_page_of factlink


    within_evidence_list do
      expect(all '.evidence-votable', visible: false).to be_empty
    end
  end

  scenario "after adding a piece of evidence, evidence list should contain that item" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    add_existing_factlink :supporting, supporting_factlink
    sleep 2
    within ".evidence-votable", visible: false do
      page.should have_content supporting_factlink.to_s
    end
  end

  scenario "we can click on evidence to go to the page of that factlink" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    add_existing_factlink :supporting, supporting_factlink

    find('.evidence-impact-text', text: "0.0") # wait until request has finished

    find('.evidence-votable span', text: supporting_factlink.to_s).click

    find('.top-fact-text', text: supporting_factlink.to_s)
  end

  scenario "we can click on evidence to go to the page of that factlink in the client" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    add_existing_factlink :supporting, supporting_factlink

    find('.evidence-impact-text', text: "0.0") # wait until request has finished

    go_to_fact_show_of factlink

    find('.evidence-votable span', text: supporting_factlink.to_s).click

    find('.top-fact-text', text: supporting_factlink.to_s)
  end

  scenario "after clicking the factwheel, the impact and percentages should update" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    add_existing_factlink :supporting, supporting_factlink

    within ".evidence-votable", visible: false do
      page.should have_content supporting_factlink.to_s

      find('.evidence-impact-text', text: "0.0")

      click_wheel_part 0, '.evidence-votable'
      sleep 2

      find('.evidence-impact-text', text: "1.0")
    end
  end

  scenario "factlink should show Arguments (1) on profile page" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    add_existing_factlink :supporting, supporting_factlink

    visit user_path(@user)

    page.should have_content 'Arguments (1)'
  end

  scenario "setting opinion through popup" do
    supporting_factlink = backend_create_fact

    go_to_discussion_page_of factlink
    add_existing_factlink :supporting, supporting_factlink

    within ".evidence-votable", visible: false do
      page.should have_content supporting_factlink.to_s

      find('.evidence-impact-text', text: '0.0')
      find('.evidence-impact-vote-down').click
      find('.evidence-impact-text', text: '—')
      find('.evidence-impact-vote-up').click
      find('.spec-fact-believe').click
      find('.evidence-impact-text', text: '1.0')
    end
  end
end
