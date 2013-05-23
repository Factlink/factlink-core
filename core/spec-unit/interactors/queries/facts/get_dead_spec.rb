require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead.rb'
require_relative '../../../../app/entities/dead_fact.rb'

describe Queries::Facts::GetDead do
  include PavlovSupport

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Fact',Class.new)
    end

    it 'returns a fact' do
      fact_data = mock displaystring: 'example fact text', created_at: 15
      live_fact = mock :fact, id: '1', has_site?: false, data: fact_data
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.id).to eq live_fact.id
      expect(dead_fact.displaystring).to eq live_fact.data.displaystring
      expect(dead_fact.created_at).to eq live_fact.data.created_at
      expect(dead_fact.title).to eq live_fact.data.title
    end

    it 'returns a fact which has no site without site_url' do
      fact_data = mock displaystring: 'example fact text', created_at: 15
      live_fact = mock :fact, id: '1', has_site?: false, data: fact_data
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.site_url).to be_nil
    end

    it 'returns a fact which has a site with site_url' do
      fact_data = mock displaystring: 'example fact text', created_at: 15
      site = mock :site, url: 'http://example.org/'
      live_fact = mock :fact, id: '1', has_site?: true, site: site, data: fact_data
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.site_url).to eq site.url
    end
  end
end
