require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/global_features/set'

describe Interactors::GlobalFeatures::Set do
  include PavlovSupport

  before do
    stub_classes 'Ability::FactlinkWebapp'
  end

  describe '#call' do
    it 'passes valid, authorized requests on to the command' do
      ability = double
      ability.stub(:can?).with(:configure, Ability::FactlinkWebapp).and_return(true)

      pavlov_options = { ability: ability }

      features = ['I', 'see', 'pretty', 'things']
      interactor = described_class.new features: features, pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
        .with(:'global_features/set', features: features, pavlov_options: pavlov_options )

      interactor.call
    end
  end

  describe '#authorized?' do
    it 'requires system management access' do
      ability = double
      ability.stub(:can?).with(:configure, Ability::FactlinkWebapp).and_return(false)

      pavlov_options = { ability: ability }

      interactor = described_class.new features: [], pavlov_options: pavlov_options
      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied
    end
  end

  describe 'validation' do
    it 'requires an array as' do
      ability = double can?: true

      pavlov_options = { ability: ability }

      interactor = described_class.new features: 'string', pavlov_options: pavlov_options

      expect do
        interactor.call
      end.to raise_error(RuntimeError, 'features should be an array')
    end
  end

end
