require 'integration_helper'

feature "adding comments to a fact", type: :request do
  include Acceptance::FactHelper

  background do
    @user = sign_in_user create :approved_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = 'Geert is een buffel'
    add_comment_with_toggle comment

    # Input should be empty
    find_field('add_comment').value.blank?.should be_true

    within '.comments-listing' do
      page.should have_content comment
    end

    go_to_discussion_page_of factlink # Reload the page

    within '.comments-listing' do
      page.should have_content comment
    end

  end


  scenario 'after voting a comment it should have brain cycles' do

    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment_with_toggle comment

    within '.comments-listing' do
      find('.supporting').click
    end

    go_to_discussion_page_of factlink

    within '.comments-listing' do
      find('.total-authority-evidence').should have_content 17
    end
  end


  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment_with_toggle comment1
    add_comment comment2

    within '.comments-listing' do
      page.should have_content comment1
      page.should have_content comment2
    end

    go_to_discussion_page_of factlink # Reload the page

    within '.comments-listing' do
      page.should have_content comment1
      page.should have_content comment2
    end
  end


  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment_with_toggle comment

    within '.comments-listing' do
      find('.evidence-popover-arrow').click
      find('.delete').click
      wait_for_ajax
    end

    page.should_not have_content comment

    go_to_discussion_page_of factlink

    page.should_not have_content comment
  end
end


def add_comment_with_toggle comment
  evidence_input = page.find_field 'add_factrelation'

  evidence_input.trigger 'focus'
  evidence_input.set comment
  evidence_input.trigger 'blur'

  page.find('.js-switch').set(true)

  click_button 'Post comment'
  wait_for_ajax
end


def add_comment comment
  comment_input = page.find_field 'add_comment'

  comment_input.trigger 'focus'
  comment_input.set comment
  comment_input.trigger 'blur'

  click_button 'Post comment'
  wait_for_ajax
end
