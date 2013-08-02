require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/global_features/index'

describe Queries::GlobalFeatures::Index do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe '#call' do
    it do
      query    = described_class.new
      features = ['see_pretty_things', 'can_rule_world']
      set      = double( smembers: features )

      Nest.stub(:new)
        .with(:admin_global_features)
        .and_return(set)

      expect( query.call ).to eq features
    end
  end
end
