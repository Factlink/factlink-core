require 'integration_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :request do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :active_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = 'Geert is een buffel'
    add_comment comment

    # Input should be empty
    find_field('add_comment').value.blank?.should be_true

    find(evidence_listing_css_selector).should have_content comment

    go_to_discussion_page_of factlink # Reload the page

    find(evidence_listing_css_selector).should have_content comment
  end

  scenario 'after adding a comment it should have brain cycles' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    go_to_discussion_page_of factlink

    within evidence_listing_css_selector do
      find('.total-authority-evidence').should have_content user_authority_on_fact + 1
    end
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    within evidence_listing_css_selector do
      find(evidence_item_css_selector, text: comment).find('.supporting').click
      find(evidence_item_css_selector, text: comment).find('.total-authority-evidence', text: "0.0")
    end

    go_to_discussion_page_of factlink

    within evidence_listing_css_selector do
      find('.total-authority-evidence', text: "0.0")
    end
  end

  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment comment1
    add_comment comment2

    find(evidence_listing_css_selector).should have_content comment1
    find(evidence_listing_css_selector).should have_content comment2

    go_to_discussion_page_of factlink # Reload the page

    find(evidence_listing_css_selector).should have_content comment1
    find(evidence_listing_css_selector).should have_content comment2
  end

  scenario 'comments and facts should be sorted on relevance' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    factlink2 = 'Henk ook niet'
    comment3 = 'Geert is een baas'

    add_comment comment1
    add_new_factlink factlink2
    add_comment comment3

    # make sure sorting is done:
    sleep 1

    within('.fact-relation-listing .evidence-item', text: comment1) do
      find('.weakening').click
    end
    within('.fact-relation-listing .evidence-item', text: comment3) do
      find('.supporting').click
    end

    go_to_discussion_page_of factlink

    within evidence_listing_css_selector do
      items = all evidence_item_css_selector
      expect(items[0].text).to match (Regexp.new factlink2)
      expect(items[1].text).to match (Regexp.new comment3)
      expect(items[2].text).to match (Regexp.new comment1)
    end
  end

  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment

    within evidence_listing_css_selector do
      find('.evidence-popover-arrow').click
      find('.delete').click
    end

    page.should_not have_content comment

    go_to_discussion_page_of factlink

    page.should_not have_content comment
  end

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
end
