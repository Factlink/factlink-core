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

    let(:votes) { double }
    let(:believable) { double }

    let(:site) do
      double :site, url: 'http://example.org/'
    end

    let(:live_fact) do
      double :fact,
        id: '2',
        site: site,
        data: fact_data,
        believable: believable
    end

    before do
      Fact.stub(:[])
          .with(live_fact.id)
          .and_return(live_fact)
    end

    it 'returns a fact' do
      interactor = Queries::Facts::GetDead.new id: live_fact.id

      dead_fact = interactor.call

      expect(dead_fact.id).to eq live_fact.id
      expect(dead_fact.displaystring).to eq live_fact.data.displaystring
      expect(dead_fact.created_at).to eq live_fact.data.created_at
      expect(dead_fact.site_title).to eq live_fact.data.title
      expect(dead_fact.site_url).to eq site.url
    end
  end
end
