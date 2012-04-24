require 'spec_helper'

describe UserMailer do
	describe 'welcome_instructions' do
		let(:user) { FactoryGirl.create :user, reset_password_token: 'r3S3tT0k3n' }
		let(:mail) { UserMailer.welcome_instructions(user) }

		it 'renders the subject' do
			mail.subject.should == 'Start using Factlink'
		end

		it 'renders the receiver email' do
			mail.to.should == [user.email]
		end

		it 'renders the sender email' do
			mail.from.should == ['no-reply@factlink.com']
		end

		it 'assigns the set password link' do
			mail.body.encoded.should match("reset_password_token=")
		end

	end
end