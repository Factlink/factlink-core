require 'spec_helper'
require 'integration_helper'

describe "the sign in process", :type => :request do

  before :each do
    @user = int_user
    visit "/"
  end

  it "signs me in", js: true do
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password

    click_button 'Sign in'

    within(:css, "h1") do
      page.should have_content("All")
    end

    page.should have_content("Sign out")
  end
end