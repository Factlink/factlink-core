require 'spec_helper'

describe Interactors::Accounts::Setup do
  include PavlovSupport

  describe 'a user with a confirmed account' do
    it 'resets password, sets attributes, and removes reset_password_token' do
      user = create :user, :confirmed
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example',
        full_name: 'Henk Pietersen',
        reset_password_token: 'token'
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      interactor.call

      updated_user = User.find(user.id)

      expect(updated_user.valid_password?(attributes[:password])).to be_true
      expect(updated_user.full_name).to eq attributes[:full_name]
      expect(updated_user.reset_password_token).to be_nil
    end

    it 'returns a user with errors if no name was given' do
      user = create :user, :confirmed
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example',
        full_name: '',
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      returned_user = interactor.call

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:full_name]).to match_array ["is required"]
    end

    it "returns a user with errors if the passwords don't match" do
      user = create :user, :confirmed
      attributes = {
        user: user,
        password: 'example',
        password_confirmation: 'example2',
        full_name: 'Henk Pietersen'
      }
      interactor = described_class.new(user: user, attribuutjes: attributes)

      returned_user = interactor.call

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:password]).to match_array ["doesn't match confirmation"]
    end
  end
end
