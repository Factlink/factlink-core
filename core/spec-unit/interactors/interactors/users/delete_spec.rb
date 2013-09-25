require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/delete'

describe Interactors::Users::Delete do
  include PavlovSupport
  before do
    stub_classes 'User'
  end

  describe '#authorized?' do
    it 'throws when non-existant user passed' do
      user_id = 'a1234'
      User.stub(:find).with(user_id).and_return(nil)
      ability = double(:ability)
      ability.stub(:can?).with(:delete, nil).and_return(false)

      interactor = described_class.new(
          user_id: user_id,
          current_user_password: '',
          pavlov_options: { ability: ability }
      )
      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end

    it 'throws when unauthorized' do
      other_user = double(:user, id: 'b234')

      ability = double(:ability)

      User.stub(:find).with(other_user.id).and_return(other_user)

      ability.stub(:can?).with(:delete, other_user).and_return(false)

      interactor = described_class.new(
          user_id: other_user.id,
          current_user_password: '',
          pavlov_options: {ability: ability}
      )
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end

    it 'is authorized when cancan says so' do
      user = double(:user, id: 'a123')
      User.stub(:find).with(user.id).and_return(user)
      ability = double(:ability)
      ability.stub(:can?).with(:delete, user).and_return(true)

      interactor = described_class.new(
          user_id: user.id,
          current_user_password: '',
          pavlov_options: {ability: ability}
      )

      expect(interactor.authorized?).to eq(true)
    end
  end

  describe '#validate' do
    it 'raises when user_id is a Fixnum' do
      expect_validating(user_id: 12,
                        current_user_password: '',
        ).to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'raises when user_id is missing' do
      expect_validating(current_user_password: '')
        .to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'raises when current_user_password is missing' do
      expect_validating(user_id: 'a123')
        .to fail_validation
    end
  end

  describe '#call' do
    it 'it calls the delete+anonymize commands' do
      user = double(:user, id: 'a234')
      ability = double(:ability)
      ability.stub(:can?).with(:delete, user).and_return(true)
      pavlov_options = { ability: ability }

      User.stub(:find).with(user.id).and_return(user)

      interactor = described_class.new(
          user_id: user.id,
          current_user_password: '',
          pavlov_options: pavlov_options
        )

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
