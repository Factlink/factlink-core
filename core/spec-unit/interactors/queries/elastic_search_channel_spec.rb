require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_channel.rb'

describe Queries::ElasticSearchChannel do
  include PavlovSupport

  let(:base_url) { base_url = '1.0.0.0:4000/index' }

  before do
    stub_classes 'Topic', 'HTTParty', 'FactlinkUI::Application', 'Logger'

    FactlinkUI::Application.stub(config: double(elasticsearch_url: base_url))
  end

  describe '#call' do
    it "invokes queries/elastic_search" do
      keywords = 'searching for this channel'
      wildcard_keywords = '(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)'
      query = described_class.new keywords: keywords, page: 1,
        row_count: 20
      result = mock

      Pavlov.stub(:query)
            .with(:elastic_search, keywords: keywords, page: 1,
                     row_count: 20, types: [:topic])
            .and_return(result)

      query.call.should eq result
    end
  end
end
