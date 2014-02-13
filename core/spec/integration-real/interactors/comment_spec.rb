require 'spec_helper'

describe 'comments' do
  include PavlovSupport

  let(:current_user) { create :full_user }

  before do
    ElasticSearch.stub synchronous: true
  end

  describe 'initially' do
    it 'a fact has no comments' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', title: ''

        comments = pavlov.interactor :'comments/for_fact_id', fact_id: fact.id.to_s, type: :believes

        expect(comments).to eq []
      end
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      as(current_user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', title: ''

        pavlov.interactor :'comments/create', fact_id: fact.id.to_i, type: 'believes', content: 'Gekke Gerrit'
        pavlov.interactor :'comments/create', fact_id: fact.id.to_i, type: 'believes', content: 'Handige Harrie'

        comments = pavlov.interactor :'comments/for_fact_id', fact_id: fact.id.to_s, type: :believes

        expect(comments.map(&:formatted_content)).to eq ['Gekke Gerrit', 'Handige Harrie']
      end
    end
  end
end
