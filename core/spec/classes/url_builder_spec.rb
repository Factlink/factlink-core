require_relative '../../app/classes/url_builder'

describe UrlBuilder do

  describe '.fact_url' do

    it 'returns the correct url for a fact' do
      stub_const 'FactlinkUI::Application', Class.new

      fact     = stub id: '1'
      config   = stub core_url: "https://factlink.com/"
      FactlinkUI::Application.stub( config: config)

      expect(described_class.fact_url fact).to eq "https://factlink.com/facts/1"
    end
  end

  describe '.full_url' do
    it 'combines url and uri' do
      url = 'http://foo.com'
      uri = 'bar/33/coffee'

      UrlBuilder.stub(:application_url)
                .and_return(url)

      expect( UrlBuilder.full_url(uri) ).to eq "#{url}/#{uri}"
    end
  end

  describe '.application_url' do
    it 'uses the core application url' do
      stub_const 'FactlinkUI::Application', Class.new

      core_url = "https://factlink.com/"

      config = mock
      config.should_receive(:core_url)
        .and_return( core_url )

      FactlinkUI::Application.stub( config: config)

      expect(described_class.application_url).to eq core_url
    end
  end

end
