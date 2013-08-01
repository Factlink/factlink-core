require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_all.rb'

describe Queries::ElasticSearchAll do
  include PavlovSupport

  let(:base_url) { '1.0.0.0:4000/index' }

  before do
    stub_classes 'HTTParty', 'FactData', 'User',
      'FactlinkUI::Application', 'FactlinkUser'
      FactlinkUI::Application.stub(config: double(elasticsearch_url: base_url))
  end

  describe '#call' do
    ['user', 'factdata'].each do |type|
      it "correctly with return value of #{type} class" do
        keywords = 'searching for this channel'
        wildcard_keywords = '(searching*%20OR%20searching)+(for*%20OR%20for)+(this*%20OR%20this)+(channel*%20OR%20channel)'
        query = described_class.new keywords: keywords, page: 1,
          row_count: 20
        hit = double
        results = double(code: 200,
          parsed_response: { 'hits' => { 'hits' => [hit] } })

        hit.should_receive(:[]).with('_id').and_return(1)
        hit.should_receive(:[]).with('_type').and_return(type)

        HTTParty.should_receive(:get).
          with("http://#{base_url}/factdata,topic,user/_search?q=(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)&from=0&size=20&analyze_wildcard=true").
          and_return(results)

        return_object = double

        case type
        when 'user'
          user_mock_id = double
          mongoid_user = double(id: user_mock_id)
          User.should_receive(:find).
            with(1).
            and_return(mongoid_user)
          FactlinkUser.should_receive(:map_from_mongoid)
            .with(mongoid_user)
            .and_return(return_object)
        when 'topic'
          fail 'We test topics in elastic_search_channel_spec'
        when 'factdata'
          FactData.should_receive(:find).
            with(1).
            and_return(return_object)
        end

        query.call.should eq [return_object]
      end
    end

    it 'logs and raises an error when HTTParty returns a non 2xx status code.' do
      keywords = 'searching for this channel'
      results = double
      error_response = 'error has happened server side'
      results.stub response: error_response
      results.stub code: 501
      logger = double
      error_message = "Server error, status code: 501, response: '#{error_response}'."
      query = described_class.new(keywords: keywords, page: 1, row_count: 20, pavlov_options: { logger: logger })

      logger.should_receive(:error).with(error_message)
      HTTParty.stub get: results

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      results = double(code: 200,
        parsed_response: { 'hits' => { 'hits' => [] } })
      query = described_class.new(keywords: keywords, page: 1, row_count: 20)

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata,topic,user/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      query.call.should eq []
    end
  end
end
