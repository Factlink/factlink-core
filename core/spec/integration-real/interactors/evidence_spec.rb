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
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}

        evidence = pavlov.old_interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(evidence).to eq []
      end
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      as(current_user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}

        pavlov.old_interactor :'comments/create', fact.id.to_i, 'believes', 'Gekke Gerrit'
        pavlov.old_interactor :'comments/create', fact.id.to_i, 'believes', 'Handige Harrie'

        evidence = pavlov.old_interactor :'evidence/for_fact_id', fact.id.to_s, :supporting

        expect(evidence.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
      end
    end
  end
end
