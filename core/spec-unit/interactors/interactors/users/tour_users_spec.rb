require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/tour_users'

describe Interactors::Users::TourUsers do
  include PavlovSupport

  before do
      stub_classes 'User'
  end

  describe '#authorized?' do
    it 'check if User can be indexed' do
      ability = mock
      ability.stub(:can?).with(:index, User).and_return(false)

      expect do
        interactor = described_class.new ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'always succeeds' do
      described_class.new ability: mock(can?: true)
    end
  end

  describe '#execute' do
    it 'calls the handpicked users query' do
      dead_users = mock
      options = { ability: mock(can?: true) }

      interactor = described_class.new options
      Pavlov.should_receive(:query)
            .with(:'users/handpicked', options)
            .and_return(dead_users)

      expect(interactor.call).to eq dead_users
    end
  end

end
