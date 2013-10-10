require 'spec_helper'

describe MailSubscriptionsController do
  let (:user)  { create :full_user }

  describe "#update" do
    it 'works' do
      post :update,
           token: user.notification_settings_edit_token,
           type: 'digest'

      expect(response).to be_success
      refetched_user = User.find(user.id)
      expect(refetched_user.receives_digest).to be_false
    end
  end
end
