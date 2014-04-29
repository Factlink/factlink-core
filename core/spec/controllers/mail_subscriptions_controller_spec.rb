require 'spec_helper'

describe MailSubscriptionsController do
  let (:user)  { create :user }

  render_views

  describe "#update" do
    it 'works' do
      SendUnsubscribeMailToUser.stub_chain('new.async.perform')

      post :update,
           token: user.notification_settings_edit_token,
           type: 'digest',
           subscribe_action: :unsubscribe

      expect(response).to be_success
      expect(response.body).to match 'succesfully'
      refetched_user = User.find(user.id)
      expect(refetched_user.receives_digest).to be_false
    end

    it 'mails the user' do
      job = double
      mailer = double
      job.stub async: job
      allow(SendUnsubscribeMailToUser).to receive(:new)
        .and_return(job)
      expect(job).to receive(:perform)
        .with(user.id, 'digest')
        .and_return mailer

      post :update,
           token: user.notification_settings_edit_token,
           type: 'digest',
           subscribe_action: :unsubscribe
    end

  end
end
