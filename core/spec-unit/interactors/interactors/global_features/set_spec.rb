require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/global_features/set'

describe Interactors::GlobalFeatures::Set do
  include PavlovSupport

  describe '#call' do
    it do
      features = ['I', 'see', 'pretty', 'things']
      interactor = described_class.new features

      Pavlov.should_receive(:command)
        .with(:'global_features/set', features)

      interactor.call
    end
  end

  describe '#authorized?' do
    pending 'requires user to be admin' do
    end
  end

  describe 'validation' do
    it 'requires an array as' do
      expect { described_class.new 'string' }
        .to raise_error(RuntimeError, 'features should be an array')
    end
  end

end
