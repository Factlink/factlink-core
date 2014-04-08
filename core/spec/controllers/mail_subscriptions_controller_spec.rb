require 'spec_helper'

describe MailSubscriptionsController do
  let (:user)  { create :user }

  render_views

  describe "#update" do
    it 'works' do
      post :update,
           token: user.notification_settings_edit_token,
           type: 'digest',
           subscribe_action: :unsubscribe

      expect(response).to be_success
      expect(response.body).to match 'succesfully'
      refetched_user = User.find(user.id)
      expect(refetched_user.receives_digest).to be_false
    end
  end
end
