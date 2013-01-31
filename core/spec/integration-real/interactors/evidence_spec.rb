require 'spec_helper'

describe 'evidence' do
  include Pavlov::Helpers

  let(:current_user) { create :user }

  def pavlov_options
    {current_user: current_user}
  end

  before do
    ElasticSearch.stub synchronous: true
  end

  describe 'initially' do
    it 'a fact has no evidence' do
      f = create :fact

      evidence = interactor :'evidence/for_fact_id', f.id.to_s, :supporting

      expect(evidence).to eq []
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      f = create :fact, created_by: (create :user).graph_user

      interactor :'comments/create', f.id.to_i, 'believes', 'Gekke Gerrit'
      interactor :'comments/create', f.id.to_i, 'believes', 'Handige Harrie'

      evidence = interactor :'evidence/for_fact_id', f.id.to_s, :supporting

      expect(evidence.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
    end
  end
end
