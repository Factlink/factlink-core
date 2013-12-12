require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/facts_count'

describe Queries::Topics::FactsCount do
  include PavlovSupport

  before do
    stub_classes 'Topic'
  end

  describe '#call' do
    it 'correctly' do
      slug_title = 'slug-title'
      facts_key = double
      count = double

      query = described_class.new slug_title: slug_title

      nest = double
      key = double
      facts_key = double

      Topic.should_receive(:redis).and_return(nest)
      nest.should_receive(:[]).with(slug_title).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(facts_key)
      facts_key.should_receive(:zcard).and_return(count)

      expect( query.call ).to eq count
    end
  end
end
