require 'acceptance_helper'

describe "Facebook", type: :feature do
  include Acceptance::FactHelper

  context "as a logged in user with expired token" do
    before do
      @user = sign_in_user create :user, :confirmed

      social_account = create :social_account, :facebook, user: @user
      social_account.omniauth_obj['credentials']['expires_at'] = DateTime.now.to_i
      social_account.save
    end

    it "contains the iframe" do
      visit "/"

      expect(page).to have_selector ".facebook_renewal_iframe"
    end

    it "contains the iframe in the client" do
      factlink = backend_create_fact
      go_to_discussion_page_of factlink

      expect(page).to have_selector ".facebook_renewal_iframe"
    end
  end

  context "as a logged in user with valid token" do
    before do
      @user = sign_in_user create :user, :confirmed
      create :social_account, :facebook, user: @user
    end

    it "doesn't contain the iframe" do
      visit "/"

      expect(page).to_not have_selector ".facebook_renewal_iframe"
    end
  end
end
