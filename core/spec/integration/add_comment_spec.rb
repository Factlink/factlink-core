require 'integration_helper'

feature "adding comments to a fact", type: :request do
  include Acceptance::FactHelper

  background do
    @user = sign_in_user create :approved_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "adding a comment" do

    go_to_discussion_page_of factlink

    text = 'Geert is een buffel'

    add_comment text

    screenshot_and_open_image
  end

  scenario "adding multiple comments" do
  end

  scenario "deleting a comment" do
  end

end

def add_comment comment
  evidence_input = page.find_field('add_factrelation')

  evidence_input.trigger 'focus'
  evidence_input.set comment
  evidence_input.trigger 'blur'

  page.find('.js-switch').set(true)

  click_button 'Post comment'
end
