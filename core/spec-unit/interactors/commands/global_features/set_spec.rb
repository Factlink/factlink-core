require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/global_features/set'

describe Commands::GlobalFeatures::Set do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe '#call' do
    it do
      features = ['see_pretty_things', 'can_rule_world']
      command  = described_class.new features

      set = double

      Nest.stub(:new)
        .with(:admin_global_features)
        .and_return(set)
      set.should_receive(:del)
      set.should_receive(:sadd)
        .with(features[0])
      set.should_receive(:sadd)
        .with(features[1])

      command.call
    end
  end
end
