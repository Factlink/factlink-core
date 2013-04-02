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
        f = create :fact

        evidence = pavlov.interactor :'evidence/for_fact_id', f.id.to_s, :supporting

        expect(evidence).to eq []
      end
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      as(current_user) do |pavlov|
        f = create :fact, created_by: (create :user).graph_user

        pavlov.interactor :'comments/create', f.id.to_i, 'believes', 'Gekke Gerrit'
        pavlov.interactor :'comments/create', f.id.to_i, 'believes', 'Handige Harrie'

        evidence = pavlov.interactor :'evidence/for_fact_id', f.id.to_s, :supporting

        expect(evidence.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
      end
    end
  end
end
