require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_channel.rb'

describe Queries::ElasticSearchChannel do
  include PavlovSupport

  let(:base_url) { base_url = '1.0.0.0:4000/index' }

  before do
    stub_classes 'Topic', 'HTTParty', 'FactlinkUI::Application', 'Logger'
    Logger.stub(:new)

    FactlinkUI::Application.stub(config: double(elasticsearch_url: base_url))
  end

  describe '#call' do
    it 'correctly' do
      keywords = 'searching for this channel'
      wildcard_keywords = '(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)'
      query = described_class.new keywords, 1, 20
      hit = double
      results = double(parsed_response: { 'hits' => { 'hits' => [ hit ] } },
        code: 200)
      url = 'test'
      return_object = double

      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')
      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)
      query.stub(:old_query).
        with(:'topics/by_id_with_authority_and_facts_count', 1).
        and_return(return_object)

      query.call.should eq [return_object]
    end

    it 'logs and raises an error when HTTParty returns a non 2xx status code.' do
      keywords = 'searching for this channel'
      results = double(response: 'error has happened server side',
        code: 501)
      logger = double
      query = described_class.new keywords, 1, 20, logger: logger

      HTTParty.should_receive(:get).and_return(results)
      error_message = "Server error, status code: 501, response: '#{results.response}'."
      logger.should_receive(:error).with(error_message)

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      query = described_class.new keywords, 1, 20
      hit = double
      results = double(parsed_response: { 'hits' => { 'hits' => [ hit ] } },
        code: 200)
      query.stub get_object: stub

      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')

      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      query.call
    end
  end
end
