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
      live_fact = mock :fact, id: '1', has_site?: false
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.id).to eq live_fact.id
    end

    it 'returns a fact which has no site without site_url' do
      live_fact = mock :fact, id: '1', has_site?: false
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.site_url).to be_nil
    end
    it 'returns a fact which has a site with site_url' do
      site = mock :site, url: 'http://example.org/'
      live_fact = mock :fact, id: '1', has_site?: true, site: site
      interactor = Queries::Facts::GetDead.new live_fact.id

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact = interactor.execute

      expect(dead_fact.site_url).to eq site.url
    end
  end
end
