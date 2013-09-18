require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/tour_users'

describe Interactors::Users::TourUsers do
  include PavlovSupport

  before do
    stub_classes 'User', 'KillObject'
  end

  describe '#authorized?' do
    it 'check if User can be indexed' do
      ability = double
      ability.stub(:can?).with(:index, User).and_return(false)

      expect do
        interactor = described_class.new(pavlov_options: { ability: ability })
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'always succeeds' do
      described_class.new(pavlov_options: { ability: double(can?: true) })
    end
  end

  describe '#call' do
    it 'calls the handpicked users query' do
      users = double

      options = { ability: double(can?: true) }

      interactor = described_class.new(pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'users/handpicked',
                      pavlov_options: options)
            .and_return(users)

      expect(interactor.call).to eq users
    end
  end

end
