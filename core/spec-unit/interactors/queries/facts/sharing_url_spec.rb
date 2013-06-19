require 'pavlov_helper'
require_relative '../../../../app/helpers/fact_helper.rb'
require_relative '../../../../app/interactors/queries/facts/sharing_url.rb'

describe Queries::Facts::SharingUrl do
  include PavlovSupport

  describe '#call' do
    it 'returns the proxy_scroll_url if available' do
      fact = mock(id: "1", proxy_scroll_url: "proxy_scroll_url")

      query = described_class.new fact

      expect(query.call).to eq fact.proxy_scroll_url
    end

    it 'returns the friendly_fact_url otherwise' do
      fact = mock(id: "1", proxy_scroll_url: nil, slug: 'slug')
      friendly_fact_url = "friendly_fact_url"

      stub_classes('FactUrl')

      url_builder = stub friendly_fact_url: friendly_fact_url
      FactUrl.stub(:new)
                .with(fact)
                .and_return(url_builder)

      query = described_class.new fact

      expect(query.call).to eq friendly_fact_url
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact = mock

      described_class.any_instance.should_receive(:validate_not_nil)
        .with(:fact, fact)

      interactor = described_class.new fact
    end
  end
end
