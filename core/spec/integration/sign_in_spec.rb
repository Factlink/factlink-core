require 'spec_helper'
require 'integration_helper'

describe "the sign in process", :type => :request do
  before :each do
    @user = Factory.create(:user, email: "user@example.com")
    @user.confirm!

    visit "/"
  end

  it "signs me in" do
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password

    click_button 'Sign in'
  end
end