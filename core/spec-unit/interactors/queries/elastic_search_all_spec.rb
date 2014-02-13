require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_all.rb'

describe Queries::ElasticSearchAll do
  include PavlovSupport

  let(:base_url) { '1.0.0.0:4000/index' }

  before do
    stub_classes 'HTTParty', 'FactData', 'User',
      'FactlinkUI::Application', 'KillObject', 'Queries::Facts::GetDead'
    FactlinkUI::Application.stub(config: double(elasticsearch_url: base_url))
  end

  describe '#call' do
    ['user', 'factdata'].each do |type|
      it "correctly with return value of #{type} class" do
        keywords = 'searching for this channel'
        query = described_class.new keywords: keywords, page: 1, row_count: 20
        hit = {
          '_id' => 1,
          '_type' => type
        }
        results = double code: 200, parsed_response: { 'hits' => { 'hits' => [hit] } }


        HTTParty.should_receive(:get).
          with("http://#{base_url}/factdata,user/_search?q=(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)&from=0&size=20&analyze_wildcard=true").
          and_return(results)

        return_object = double

        case type
        when 'user'
          # Cannot stub Pavlov.query because this query uses another query
          users_by_ids = double call: [return_object]
          stub_classes 'Queries::DeadUsersByIds'
          Queries::DeadUsersByIds
            .stub(:new)
            .with(user_ids: [1])
            .and_return(users_by_ids)
        when 'factdata'
          fd = double fact_id: 1
          FactData.should_receive(:find).
            with(1).
            and_return(fd)
          get_dead_fact = double call: return_object
          Queries::Facts::GetDead.stub(:new).with(id: fd.fact_id).and_return(get_dead_fact)
        end

        expect(query.call).to eq [return_object]
      end
    end

    it 'logs and raises an error when HTTParty returns a non 2xx status code.' do
      keywords = 'searching for this channel'
      error_response = 'error has happened server side'
      results = double code: 501, response: error_response

      error_message = "Server error, status code: 501, response: '#{error_response}'."
      query = described_class.new(keywords: keywords, page: 1, row_count: 20)

      HTTParty.stub get: results

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      results = double code: 200, parsed_response: { 'hits' => { 'hits' => [] } }
      query = described_class.new(keywords: keywords, page: 1, row_count: 20)

      HTTParty.should_receive(:get)
        .with("http://#{base_url}/factdata,user/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true")
        .and_return(results)

      expect(query.call).to eq []
    end
  end
end
