require 'spec_helper'

describe 'evidence' do
  include PavlovSupport

  let(:current_user) { create :user }

  before do
    ElasticSearch.stub synchronous: true
  end

  describe 'initially' do
    it 'a fact has no evidence' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}

        evidence = pavlov.interactor :'evidence/for_fact_id', fact_id: fact.id.to_s, type: :supporting

        expect(evidence).to eq []
      end
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}

        pavlov.interactor :'comments/create', fact_id: fact.id.to_i, type: 'believes', content: 'Gekke Gerrit'
        pavlov.interactor :'comments/create', fact_id: fact.id.to_i, type: 'believes', content: 'Handige Harrie'

        evidence = pavlov.interactor :'evidence/for_fact_id', fact_id: fact.id.to_s, type: :supporting

        expect(evidence.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
      end
    end
  end
end
