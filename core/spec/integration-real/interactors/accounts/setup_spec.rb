require 'spec_helper'

describe 'setting up an account' do
  include PavlovSupport

  let(:anonymous) {nil}

  before do
    stub_const 'UserMailer', Class.new
    UserMailer.stub welcome_instructions: stub(deliver: nil)
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
      user = create_approved_user 'username', 'example@example.org'

      attributes = {
        reset_password_token: user.reset_password_token,
        password: 'example',
        password_confirmation: 'example',
        first_name: 'Henk',
        last_name: 'Pietersen'
      }

      as(anonymous) do |pavlov|
        pavlov.interactor(:'accounts/setup_approved', {
          reset_password_token: user.reset_password_token, attribut: attributes})
      end

      updated_user = User.find(user.id)

      expect(updated_user.valid_password?(attributes[:password])).to be_true
      expect(updated_user.first_name).to eq attributes[:first_name]
      expect(updated_user.last_name).to eq attributes[:last_name]
      expect(updated_user.email).to eq 'example@example.org'
      expect(updated_user.reset_password_token).to be_nil
    end

    it 'returns a user with errors if no user could be found for the reset_password_token' do
      returned_user = nil

      attributes = {
        reset_password_token: 'some token',
        password: 'example',
        password_confirmation: 'example',
        first_name: 'Henk',
        last_name: 'Pietersen'
      }

      as(anonymous) do |pavlov|
        returned_user = pavlov.old_interactor :'accounts/setup_approved',
            attributes[:reset_password_token], attributes
      end

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:reset_password_token]).to match_array ["is invalid"]
    end

    it 'returns a user with errors if no first name was given' do
      user = create_approved_user 'username', 'example@example.org'
      returned_user = nil

      attributes = {
        reset_password_token: user.reset_password_token,
        password: 'example',
        password_confirmation: 'example',
        first_name: '',
        last_name: 'Pietersen'
      }

      as(anonymous) do |pavlov|
        returned_user = pavlov.old_interactor :'accounts/setup_approved',
            user.reset_password_token, attributes
      end

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:first_name]).to match_array ["is required"]
    end

    it 'returns a user with errors if the passwords don\'t match' do
      user = create_approved_user 'username', 'example@example.org'
      returned_user = nil

      attributes = {
        reset_password_token: user.reset_password_token,
        password: 'example',
        password_confirmation: 'example2',
        first_name: 'Henk',
        last_name: 'Pietersen'
      }

      as(anonymous) do |pavlov|
        returned_user = pavlov.old_interactor :'accounts/setup_approved',
          user.reset_password_token, attributes
      end

      expect(returned_user.errors.size).to eq 1
      expect(returned_user.errors[:password]).to match_array ["doesn't match confirmation"]
    end
  end
end
