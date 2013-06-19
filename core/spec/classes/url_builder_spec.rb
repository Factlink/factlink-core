require_relative '../../app/classes/url_builder'

describe UrlBuilder do

  before do
    stub_const 'FactlinkUI::Application', Class.new
    FactlinkUI::Application.stub( config: stub(core_url: "https://a-random-website.com"))
  end

  describe '.fact_url' do
    it 'returns the correct url' do
      fact = stub id: '1'

      url_builder = UrlBuilder.new fact

      expect(url_builder.fact_url)
        .to eq 'https://a-random-website.com/facts/1'
    end
  end

  describe '.friendly_fact_url' do
    it 'returns the correct url' do
      fact = stub id: '2'
      slug = 'this-is-a-friendly-fact'

      Pavlov.stub(:query)
            .with(:'facts/slug', fact, nil)
            .and_return(slug)

      url_builder = UrlBuilder.new fact

      expect(url_builder.friendly_fact_url)
        .to eq "https://a-random-website.com/this-is-a-friendly-fact/f/2"
    end
  end

end
