require 'spec_helper'

describe UserMailer do
    describe 'welcome_instructions' do
        let(:user) { create :user, reset_password_token: 'r3S3tT0k3n' }
        let(:mail) { UserMailer.welcome_instructions(user.id) }

        it 'renders the subject' do
            mail.subject.should == 'Start using Factlink'
        end

        it 'renders the receiver email' do
            mail.to.should == [user.email]
        end

        it 'renders the sender email' do
            mail.from.should == ['support@factlink.com']
        end

        it 'activation_link # contains "reset_password_token" parameter' do
            mail.body.encoded.should match("reset_password_token=")
        end

      it 'activation_link # contains "msg" parameter' do
        mail.body.encoded.should match("msg=welcome")
      end

    end
end
