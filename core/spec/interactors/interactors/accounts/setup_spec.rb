require 'spec_helper'

describe Interactors::Accounts::Setup do
  include PavlovSupport

  before do
    stub_const 'UserMailer', Class.new
    UserMailer.stub welcome_instructions: double(deliver: nil)
  end

  def create_approved_user username, email
    # method, since there is no interactor yet to do this
    user = User.new
    user.username = username
    user.email = email
    user.save validate: false
    user.send_welcome_instructions
    user
  end

  describe 'a user with an approved account' do
    it 'resets password, sets attributes, and removes reset_password_token' do
      user = create :user, :approved
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example',
        first_name: 'Henk',
        last_name: 'Pietersen',
        reset_password_token: 'token'
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      interactor.call

      updated_user = User.find(user.id)

      expect(updated_user.valid_password?(attributes[:password])).to be_true
      expect(updated_user.first_name).to eq attributes[:first_name]
      expect(updated_user.last_name).to eq attributes[:last_name]
      expect(updated_user.reset_password_token).to be_nil
    end

    it 'returns a user with errors if no first name was given' do
      user = create :user, :approved
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example',
        first_name: '',
        last_name: 'Pietersen'
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      returned_user = interactor.call

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:first_name]).to match_array ["is required"]
    end

    it "returns a user with errors if the passwords don't match" do
      user = create :user, :approved
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example2',
        first_name: 'Henk',
        last_name: 'Pietersen'
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      returned_user = interactor.call

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:password]).to match_array ["doesn't match confirmation"]
    end
  end
end
