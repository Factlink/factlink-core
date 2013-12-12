require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead.rb'
require_relative '../../../../app/entities/dead_fact.rb'

describe Queries::Facts::GetDead do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    let(:fact_data) do
      double :fact_data,
        displaystring: 'example fact text',
        created_at: 15,
        title: 'title'
    end

    let(:live_fact) do
      double :fact,
        id: '1',
        has_site?: false,
        data: fact_data,
        deletable?: false,
        believable: believable
    end

    let(:votes) { double }
    let(:believable) { double }

    let(:site) do
      double :site, url: 'http://example.org/'
    end

    let(:live_fact_with_site) do
      double :fact,
        id: '2',
        has_site?: true,
        site: site,
        data: fact_data,
        deletable?: false,
        believable: believable
    end

    before do
      Fact.stub(:[])
          .with(live_fact.id)
          .and_return(live_fact)
      Fact.stub(:[])
          .with(live_fact_with_site.id)
          .and_return(live_fact_with_site)
      Pavlov.stub(:query)
            .with(:'believable/votes', believable: believable)
            .and_return(votes)
    end

    it 'returns a fact' do
      interactor = Queries::Facts::GetDead.new id: live_fact.id

      dead_fact = interactor.call

      expect(dead_fact.id).to eq live_fact.id
      expect(dead_fact.displaystring).to eq live_fact.data.displaystring
      expect(dead_fact.created_at).to eq live_fact.data.created_at
      expect(dead_fact.title).to eq live_fact.data.title
      expect(dead_fact.votes).to eq votes
      expect(dead_fact.deletable?).to eq live_fact.deletable?
    end

    it 'returns a fact which has no site or proxy_scroll_url without site_url' do
      query = Queries::Facts::GetDead.new id: live_fact.id

      dead_fact = query.call

      expect(dead_fact.site_url).to be_nil
    end

    it 'returns a fact which has a site with site_url' do
      query = Queries::Facts::GetDead.new id: live_fact_with_site.id

      dead_fact = query.call

      expect(dead_fact.site_url).to eq site.url
    end
  end
end
