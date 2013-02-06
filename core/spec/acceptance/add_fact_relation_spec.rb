require 'acceptance_helper'

feature "adding factlinks to a fact", type: :request do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  background do
    @user = sign_in_user create :active_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "initially the evidence list should be empty" do
    go_to_discussion_page_of factlink

    within :css, ".relation-tabs-view" do
      page.should have_content "This Factlink is not supported by other Factlinks."
    end
  end

  scenario "after adding a piece of evidence, evidence list should contain that item" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink
      sleep 2
      within "li.evidence-item" do
        page.should have_content supporting_factlink.to_s
      end
    end
  end

  scenario "we can click on evidence to go to the page of that factlink" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink

      within "li.evidence-item" do
        page.find('span', text: supporting_factlink.to_s).click
      end
    end

    page.find('.fact-view .fact-body .js-displaystring', text: supporting_factlink.to_s)
  end

  scenario "we can click on the discussion link to go to the page of that factlink" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink

      within "li.evidence-item" do
        click_link 'Discussion'
      end
    end

    page.find('.fact-view .fact-body .js-displaystring', text: supporting_factlink.to_s)
  end
end
