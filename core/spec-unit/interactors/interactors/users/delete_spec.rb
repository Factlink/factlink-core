require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/delete'

describe Interactors::Users::Delete do
  include PavlovSupport


  describe '#authorized?' do
    before do
      stub_classes 'User'
      #described_class.any_instance.stub(validate: true)
    end

    it 'throws when non-existant user passed' do
      user_id = double(:user_id)
      User.stub(:find).with(user_id).and_return(nil)
      ability = double(:ability)
      ability.stub(:can?).with(:delete, nil).and_return(false)

      #TODO: initial workaround, but this self-stubbing needs cleanup
      described_class.any_instance.stub(:validate_hexadecimal_string).and_return(true)

      interactor = described_class.new(user_id: user_id, pavlov_options: { ability: ability } )
      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end

    it 'throws when unauthorized' do
      other_user = double(:user)
      other_user_id = double(:user_id)

      ability = double(:ability)

      User.stub(:find).with(other_user_id).and_return(other_user)

      ability.stub(:can?).with(:delete, other_user).and_return(false)

      #TODO: initial workaround, but this self-stubbing needs cleanup
      described_class.any_instance.stub(:validate_hexadecimal_string).and_return(true)

      interactor = described_class.new(user_id: other_user_id, pavlov_options: {ability: ability})
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end

    it 'is authorized when cancan says so' do
      user = double(:user)
      user_id = double(:user_id)

      ability = double(:ability)

      User.stub(:find).with(user_id).and_return(user)

      ability.stub(:can?).with(:delete, user).and_return(true)

      interactor = described_class.new(user_id: user_id, pavlov_options: {ability: ability})
      expect(interactor.authorized?)
        .to eq(true)
    end
  end

  describe '#validate' do
    it 'with fixnum user_id doesn\'t validate' do
      expect_validating(user_id: 12)
      .to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating({})
        .to fail_validation('user_id should be an hexadecimal string.')
    end
  end

  describe '#execute' do
    it 'it calls the delete command' do
      stub_classes 'User'

      user_id = double
      user = double
      pavlov_options = double
      User.stub(:find).with(user_id).and_return(user)

      interactor = described_class.new(user_id: user_id, pavlov_options: pavlov_options)

      Pavlov.should_receive(:command)
        .with(:'users/mark_as_deleted', user: user, pavlov_options: pavlov_options)
      interactor.execute
    end
  end
end
