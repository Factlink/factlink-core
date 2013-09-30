require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/delete'

describe Interactors::Users::Delete do
  include PavlovSupport
  before do
    stub_classes 'User', 'Util::Mixpanel'
  end

  describe '#authorized?' do
    it 'throws when non-existant user passed' do
      user_id = 'a1234'
      User.stub(:find).with(user_id).and_return(nil)

      pavlov_options = {
        ability: double(:ability),
        current_user: double(:user, :valid_password? => true)
      }

      expect(pavlov_options[:ability]).to receive(:can?).with(:destroy, nil).and_return(false)

      interactor = described_class.new user_id: user_id,
                                       current_user_password: '',
                                       pavlov_options: pavlov_options

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end

    it 'throws when unauthorized' do
      other_user = double(:user, id: 'b234')
      User.stub(:find).with(other_user.id).and_return(other_user)

      pavlov_options = {
        ability: double(:ability),
        current_user: double(:user, :valid_password? => true)
      }
      expect(pavlov_options[:ability]).to receive(:can?).with(:destroy, other_user).and_return(false)


      interactor = described_class.new(
          user_id: other_user.id,
          current_user_password: '',
          pavlov_options: pavlov_options
      )
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end

    it 'is authorized when cancan says so' do
      user = double(:user, id: 'a123')
      User.stub(:find).with(user.id).and_return(user)

      pavlov_options = {
        ability: double(:ability),
        current_user: double(:user, :valid_password? => true)
      }
      expect(pavlov_options[:ability]).to receive(:can?).with(:destroy, user).and_return(true)

      interactor = described_class.new user_id: user.id,
                                       current_user_password: '',
                                       pavlov_options: pavlov_options

      expect(interactor.authorized?).to eq(true)
    end
  end

  describe '#validate' do
    it 'raises when user_id is a Hash' do
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: double(:user, :valid_password? => true)
      }

      expect_validating(user_id: {},
                        current_user_password: '',
                        pavlov_options: pavlov_options
        ).to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'raises when user_id is missing' do
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: double(:user, :valid_password? => true)
      }
      expect_validating(current_user_password: '', user_id: '', pavlov_options: pavlov_options)
        .to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'raises when current_user_password is missing' do
      # TODO: improve check after improving pavlov
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: double(:user, :valid_password? => true)
      }
      expect_validating(user_id: 'a123', pavlov_options: pavlov_options)
        .to raise_error Pavlov::ValidationError
    end

    it 'checks current_user_password' do
      password = 'qwerty'
      user = User.new
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: user
      }

      user.should_receive(:valid_password?).with(password)
          .and_return(true)

      User.stub(:find).with('a123').and_return(user)

      interactor = described_class.new user_id: 'a123',
                                       current_user_password: password,
                                       pavlov_options: pavlov_options

      expect(interactor.valid?).to eq(true)
    end

    it 'raises when current_user_password is invalid' do
      wrong_password = 'qwerty'
      user = User.new
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: user
      }

      user.should_receive(:valid_password?).with(wrong_password)
          .and_return(false)

      User.stub(:find).with('a123').and_return(user)

      interactor = described_class.new user_id: 'a123',
                                       current_user_password: wrong_password,
                                       pavlov_options: pavlov_options

      expect(interactor.valid?).to eq(false)
    end
  end

  describe '#call' do
    it 'it calls the delete+anonymize commands' do
      user = double(:user, id: 'a234')
      pavlov_options = {
          ability: double(can?: true),
          current_user: double(valid_password?: true)
      }

      User.stub(:find).with(user.id).and_return(user)

      interactor = described_class.new user_id: user.id,
                                       current_user_password: '',
                                       pavlov_options: pavlov_options

      expect(interactor).to receive(:mp_track)

      Pavlov.should_receive(:command)
        .with(:'users/mark_as_deleted', user: user, pavlov_options: pavlov_options)
        .ordered

      Pavlov.should_receive(:command)
        .with(:'users/anonymize_user_model', user_id: user.id, pavlov_options: pavlov_options)
        .ordered

      interactor.call
    end
  end
end
