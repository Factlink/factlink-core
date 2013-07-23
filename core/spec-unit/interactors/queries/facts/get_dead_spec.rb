require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead.rb'
require_relative '../../../../app/entities/dead_fact.rb'

describe Queries::Facts::GetDead do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Fact', 'FactlinkUI::Application', 'CGI'
      FactlinkUI::Application.stub config: mock(proxy_url: "proxy_url")
      CGI.stub escape: ''

      described_class.any_instance.stub(:url).and_return("")
    end

    it 'returns a fact' do
      fact_data = mock :fact_data,
          displaystring: 'example fact text',
          created_at: 15,
          title: 'title'
      live_fact = mock :fact,
          id: '1',
          has_site?: false,
          data: fact_data

      interactor = Queries::Facts::GetDead.new live_fact.id
      wheel = mock
      evidence_count = 10

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      Pavlov.stub(:old_query)
            .with(:'facts/get_dead_wheel', live_fact.id)
            .and_return(wheel)

      Pavlov.stub(:old_query)
            .with(:'evidence/count_for_fact', live_fact)
            .and_return(evidence_count)

      dead_fact = interactor.call

      expect(dead_fact.id).to eq live_fact.id
      expect(dead_fact.displaystring).to eq live_fact.data.displaystring
      expect(dead_fact.created_at).to eq live_fact.data.created_at
      expect(dead_fact.title).to eq live_fact.data.title
      expect(dead_fact.wheel).to eq wheel
      expect(dead_fact.evidence_count).to eq evidence_count
    end

    it 'returns a fact which has no site or proxy_scroll_url without site_url' do
      fact_data = mock :fact_data,
          displaystring: 'example fact text',
          created_at: 15,
          title: 'title'
      live_fact = mock :fact,
          id: '1',
          has_site?: false,
          data: fact_data

      interactor = Queries::Facts::GetDead.new live_fact.id

      Pavlov.stub(old_query: mock)
      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.call

      expect(dead_fact.site_url).to be_nil
    end

    it 'returns a fact which has a site with site_url' do
      fact_data = mock :fact_data,
          displaystring: 'example fact text',
          created_at: 15,
          title: 'title'
      site = mock :site, url: 'http://example.org/'
      live_fact = mock :fact,
          id: '1',
          has_site?: true,
          site: site,
          data: fact_data

      interactor = Queries::Facts::GetDead.new live_fact.id

      Pavlov.stub(old_query: mock)
      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.call

      expect(dead_fact.site_url).to eq site.url
    end

  end
end
