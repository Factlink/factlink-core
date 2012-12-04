require 'spec_helper'

describe 'comments' do
  include Pavlov::Helpers

  let(:current_user) { create :user }

  def pavlov_options
    {current_user: current_user}
  end

  before do
    ElasticSearch.stub synchronous: true
  end

  describe 'initially' do
    it 'a fact has no comments' do
      f = create :fact

      comments = interactor :'comments/index', f.id.to_i, 'believes'

      expect(comments).to eq []
    end
  end

  describe 'adding a few comments' do
    it 'the fact should get the comments we add' do
      f = create :fact, created_by: (create :user).graph_user

      interactor :'comments/create', f.id.to_i, 'believes', 'Gekke Gerrit'
      interactor :'comments/create', f.id.to_i, 'believes', 'Handige Harrie'

      comments = interactor :'comments/index', f.id.to_i, 'believes'

      expect(comments.map(&:content)).to eq ['Gekke Gerrit', 'Handige Harrie']
    end
  end
end
