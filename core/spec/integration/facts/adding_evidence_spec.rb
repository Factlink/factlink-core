require "integration_helper"

feature "adding evidence to a fact", type: :request do
  include Acceptance::FactHelper

  background do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "initially the evidence list should be empty" do
    go_to_discussion_page_of factlink

    within(:css, ".relation-tabs-view") do
      page.should have_content "This Factlink is not supported by other Factlinks."
    end
  end

  scenario "after adding a piece of evidence, evidence list should contain that item" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within(".relation-tabs-view") do
      add_evidence supporting_factlink

      within("li.evidence-item") do
        page.should have_content supporting_factlink.to_s
      end
    end
  end

  scenario "we can click on evidence to go to the page of that factlink" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within(".relation-tabs-view") do
      add_evidence supporting_factlink

      within("li.evidence-item") do
        puts "Current url: #{page.current_url}"
        page.find('span', text: supporting_factlink.to_s).click
        puts "Clicked span, url: #{page.current_url}"
      end
    end
    # TODO 0312: remove comments. Sleep appears to be needed on CI?
    sleep 6
    puts "Slept for 6 seconds, url: #{page.current_url}"

    page.find('.fact-view .fact-body .js-displaystring', text: supporting_factlink.to_s)
  end

end
