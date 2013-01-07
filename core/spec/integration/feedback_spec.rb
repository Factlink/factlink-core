require 'integration_helper'

describe "Feedback modal", type: :request do

  context "as a logged out user" do

    before do
      visit "/"
      page.should have_selector "#feedback_button"
    end

    it "the form shows after clicking Feedback" do
      find('#feedback_frame').visible?.should be_false

      click_link 'Feedback'

      # Wait for feedback slide in modal animation
      sleep(1)

      find('#feedback_frame').visible?.should be_true
    end

    it "the form contains the correct input fields" do

      visit feedback_index_path

      page.should have_selector '#ticket_name',    visible: false
      page.should have_selector '#ticket_email',   visible: true
      page.should have_selector '#ticket_subject', visible: true
      page.should have_selector '#ticket_message', visible: true
    end

  end


  context "as a logged in user" do

    before do
      @user = sign_in_user FactoryGirl.create :active_user

      visit "/"

      page.should have_selector "#feedback_button"
    end

    it "the form shows after clicking Feedback" do
      find('#feedback_frame').visible?.should be_false

      click_link 'Feedback'

      sleep(1)

      find('#feedback_frame').visible?.should be_true
    end

    it "the form contains the correct input fields" do

      visit feedback_index_path

      page.should_not have_selector '#ticket_name',  visible: true
      page.should_not have_selector '#ticket_email', visible: true

      page.should have_selector '#ticket_subject'
      page.should have_selector '#ticket_message'
    end

  end

end
