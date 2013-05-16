require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/facts_count'

describe Queries::Topics::FactsCount do
  include PavlovSupport

  before do
    stub_classes 'Topic'
  end

  describe '#execute' do
    it 'correctly' do
      slug_title = 'slug-title'
      facts_key = mock
      count = mock
      
      query = described_class.new slug_title

      query.should_receive(:facts_key).and_return(facts_key)
      facts_key.should_receive(:zcard).and_return(count)

      expect( query.execute ).to eq count
    end
  end

  describe '#facts_key' do
    it 'calls nest correcly' do
      slug_title = 'slug-title'
      command = described_class.new slug_title
      nest = mock
      key = mock
      final_key = mock

      Topic.should_receive(:redis).and_return(nest)
      nest.should_receive(:[]).with(slug_title).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.facts_key).to eq final_key
    end
  end

  describe '#validation' do
    it :slug_title do
      expect_validating(1).
        to fail_validation('slug_title should be a string.')
    end
  end
end
