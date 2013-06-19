require_relative '../../app/classes/fact_url'

describe FactUrl do

  before do
    stub_const 'FactlinkUI::Application', Class.new
    config = stub core_url:  'https://a-random-website.com',
                  proxy_url: 'http://the-proxy.com'
    FactlinkUI::Application.stub(config: config)
  end

  describe '.fact_url' do
    it 'returns the correct url' do
      fact = stub id: '1'

      fact_url = FactUrl.new fact

      expect(fact_url.fact_url)
        .to eq 'https://a-random-website.com/facts/1'
    end
  end

  describe '.friendly_fact_path' do
    it 'returns the correct path' do
      fact = stub id: '2', to_s: 'THIS IS A FRIENDLY FACT'

      fact_url = FactUrl.new fact

      expect(fact_url.friendly_fact_path)
        .to eq "this-is-a-friendly-fact/f/2"
    end
  end

  describe '.friendly_fact_url' do
    it 'returns the correct url' do
      fact = stub id: '2', to_s: 'THIS IS A FRIENDLY FACT'

      fact_url = FactUrl.new fact

      expect(fact_url.friendly_fact_url)
        .to eq "https://a-random-website.com/this-is-a-friendly-fact/f/2"
    end
  end

  describe '.proxy_scroll_url' do
    it 'returns the correct url when fact has a site_url' do
      fact = stub id: '3', site_url: 'http://sciencedaily.com'

      fact_url = FactUrl.new fact

      expect(fact_url.proxy_scroll_url)
        .to eq 'http://the-proxy.com/?url=http%3A%2F%2Fsciencedaily.com&scrollto=3'
    end

    it 'returns nil when fact has no site_url' do
      fact = stub id: '4', site_url: nil

      fact_url = FactUrl.new fact
      expect(fact_url.proxy_scroll_url)
        .to eq nil
    end
  end

  describe '.sharing_url' do
    it 'returns the proxy_scroll_url when fact has a site_url' do
      fact = stub id: '3', site_url: 'http://sciencedaily.com'

      fact_url = FactUrl.new fact

      expect(fact_url.sharing_url)
        .to eq 'http://the-proxy.com/?url=http%3A%2F%2Fsciencedaily.com&scrollto=3'
    end

    it 'returns friendly_fact_url when fact has no site_url' do
      fact = stub id: '2', site_url: nil, to_s: 'THIS IS A FRIENDLY FACT'

      fact_url = FactUrl.new fact

      expect(fact_url.sharing_url)
        .to eq "https://a-random-website.com/this-is-a-friendly-fact/f/2"
    end
  end

end
