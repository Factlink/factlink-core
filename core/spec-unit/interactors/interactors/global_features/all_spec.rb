require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/global_features/all'

describe Interactors::GlobalFeatures::All do
  include PavlovSupport

  describe '#call' do
    it do
      interactor = described_class.new
      features = ['I', 'see', 'pretty', 'things']

      Pavlov.stub(:query)
        .with(:'global_features/index')
        .and_return(features)

      expect(interactor.call).to eq features
    end
  end

end
