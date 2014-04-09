require 'strict_struct'

require_relative '../../app/entities/dead_fact'
require 'cgi'
require 'uri'

describe DeadFact do

  before do
    stub_const 'FactlinkUI::Application', Class.new
    config = double core_url:  'https://site.com',
                    proxy_url: 'http://proxy.com'
    FactlinkUI::Application.stub(config: config)
  end

  def mock_fact_for_url(url)
    DeadFact.new(
      id: '123',
      site_url: url,
      displaystring: nil,
      created_at: nil,
      site_title: nil
    )
  end

  describe '.proxy_open_url' do
    it 'returns the correct url' do
      fact = mock_fact_for_url 'http://sciencedaily.com'

      expect(fact.proxy_open_url)
        .to eq 'http://proxy.com/?url=http%3A%2F%2Fsciencedaily.com#factlink-open-123'
    end
  end

  describe 'xss protection' do
    describe '.proxy_open_url' do
      it 'does not contain tags' do
        fact = mock_fact_for_url 'this<script>funky stuff'

        expect(fact.proxy_open_url)
          .not_to match '<'
        expect(fact.proxy_open_url)
          .not_to match '>'
      end
      it 'does not escape from quotes' do
        fact = mock_fact_for_url 'double " single \' quote'

        expect(fact.proxy_open_url)
          .not_to match "'"
        expect(fact.proxy_open_url)
          .not_to match '"'
      end
    end
  end
end
