require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/tour_users'

describe Interactors::Users::TourUsers do
  include PavlovSupport

  describe '.authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'should check if the fact can be shown' do
      stub_classes 'User'

      ability = mock
      ability.should_receive(:can?).with(:index, User).and_return(false)

      expect do
        interactor = described_class.new ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'always succeeds' do
      interactor = described_class.new
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls the handpicked users query' do
      dead_users = mock

      interactor = described_class.new
      interactor.should_receive(:query).
        with(:'users/handpicked').
        and_return(dead_users)

      result = interactor.execute

      expect(result).to eq dead_users
    end
  end

end
