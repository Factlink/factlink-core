require 'spec_helper'

describe "/users/_account_block.html.erb" do

  let (:user) {FactoryGirl.create :user}
  
  context "when not signed in" do
    before do
      view.stub(:user_signed_in?) { false }
      view.stub(:target) {'_blank'}
    end
    it "should display 'Sign in'" do
      render "/users/account_block"
      rendered.should match(/Sign in/)
    end
  end
  context "when signed in" do
    before do
      view.stub(:user_signed_in?) { true }
      view.stub(:current_user) { user }
      view.stub(:target) {'_blank'}
    end
    it "should display 'Signed in as' when not signed in" do
      render "/users/account_block"
      rendered.should match(/Signed in as/)
    end
  end
end
