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
    it 'requires system management access' do
      expect { described_class.new [] }
        .to raise_error Pavlov::AccessDenied
    end
  end

  describe 'validation' do
    it 'requires an array as' do
      expect { described_class.new 'string' }
        .to raise_error(RuntimeError, 'features should be an array')
    end
  end

end
