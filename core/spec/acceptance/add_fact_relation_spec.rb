require 'acceptance_helper'

feature "adding factlinks to a fact", type: :feature do
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
        click_link 'Arguments'
      end
    end

    page.find('.fact-view .fact-body .js-displaystring', text: supporting_factlink.to_s)
  end

  scenario "after clicking the factwheel, the impact and percentages should update" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink

      within ".evidence-item" do
        page.should have_content supporting_factlink.to_s

        within '.authorities-evidence' do
          page.should have_content '0.0'
        end


        agreeing_link = all('.opinion_indicators .discussion_link')[0]
        agreeing_link.should have_content "0%"

        click_wheel_part 0, '.relation-tabs-view li.evidence-item'

        # sleep 2 # Wait for the evidence to be refreshed

        authority_el = find '.authorities-evidence'
        # require 'pry'
        # binding.pry

        authority_el.should have_content '1.0'

        agreeing_link = all('.opinion_indicators .discussion_link')[0]
        agreeing_link.should have_content "100%"
      end
    end
  end

  scenario "factlink should show Arguments (1) on profile page" do
    go_to_discussion_page_of factlink

    supporting_factlink = backend_create_fact

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink
    end

    visit user_path(@user)

    page.should have_content 'Arguments (1)'
  end

  scenario "unsetting relevance" do
    use_features :vote_up_down_popup
    switch_to_user(@user)

    supporting_factlink = backend_create_fact
    go_to_discussion_page_of supporting_factlink
    click_wheel_part 0

    go_to_discussion_page_of factlink

    within ".relation-tabs-view" do
      add_existing_factlink supporting_factlink

      within "li.evidence-item" do
        page.should have_content supporting_factlink.to_s

        within '.authorities-evidence' do
          page.should have_content '1.0'
        end

        find('.supporting').click
        find('.js-fact-relation-believe').set false
        page.find('a', text: 'Done').click

        within '.authorities-evidence' do
          page.should have_content '0.0'
        end

      end
    end
  end
end
