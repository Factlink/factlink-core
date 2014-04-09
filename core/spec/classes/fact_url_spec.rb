require_relative '../../app/classes/fact_url'
require 'cgi'
require 'uri'

describe FactUrl do

  before do
    stub_const 'FactlinkUI::Application', Class.new
    config = double core_url:  'https://site.com',
                    proxy_url: 'http://proxy.com'
    FactlinkUI::Application.stub(config: config)
  end

  describe '.proxy_open_url' do
    it 'returns the correct url' do
      fact = double id: '3', site_url: 'http://sciencedaily.com'

      fact_url = FactUrl.new fact

      expect(fact_url.proxy_open_url)
        .to eq 'http://proxy.com/?url=http%3A%2F%2Fsciencedaily.com#factlink-open-3'
    end
  end

  describe '.sharing_url' do
    it 'returns the proxy_open_url' do
      fact = double id: '3', site_url: 'http://sciencedaily.com'

      fact_url = FactUrl.new fact

      expect(fact_url.sharing_url)
        .to eq 'http://proxy.com/?url=http%3A%2F%2Fsciencedaily.com#factlink-open-3'
    end
  end

  describe 'xss protection' do
    describe '.proxy_open_url' do
      it 'does not contain tags' do
        fact = double id: '22', site_url: 'this<script>funky stuff'

        fact_url = FactUrl.new fact

        expect(fact_url.proxy_open_url)
          .not_to match '<'
        expect(fact_url.proxy_open_url)
          .not_to match '>'
      end
      it 'does not escape from quotes' do
        fact = double id: '22', site_url: 'double " single \' quote'

        fact_url = FactUrl.new fact

        expect(fact_url.proxy_open_url)
          .not_to match "'"
        expect(fact_url.proxy_open_url)
          .not_to match '"'
      end
    end
  end
end
