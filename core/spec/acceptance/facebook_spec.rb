require 'acceptance_helper'

describe "Facebook", type: :feature do
  context "as a logged in user with expired token" do
    before do
      @user = sign_in_user create :full_user, :confirmed, :connected_facebook
      @user.identities['facebook']['credentials']['expires_at'] = DateTime.now.to_i
      @user.save
    end

    it "contains the iframe" do
      visit "/"

      expect(page).to have_selector ".facebook_renewal_iframe"
    end

    it "contains the iframe in the client" do
      visit new_fact_path

      expect(page).to have_selector ".facebook_renewal_iframe"
    end
  end

  context "as a logged in user with valid token" do
    before do
      @user = sign_in_user create :full_user, :confirmed, :connected_facebook
    end

    it "doesn't contain the iframe" do
      visit "/"

      expect(page).to_not have_selector ".facebook_renewal_iframe"
    end
  end
end
