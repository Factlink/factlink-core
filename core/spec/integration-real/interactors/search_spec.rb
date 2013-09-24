require 'spec_helper'

describe 'full text search' do
  include PavlovSupport
  let(:current_user) { create :full_user }

  before do
    ElasticSearch.stub synchronous: true
  end

  describe 'searching for users' do
    it 'when nothing is added, nothing is found' do
      as(current_user) do |pavlov|
        users = pavlov.interactor :search_user, keywords: 'mark'
        expect(users).to eq []
      end
    end

    it 'when a user is added he is found' do
      as(current_user) do |pavlov|
        create :full_user, username: 'mark'

        users = pavlov.interactor :search_user, keywords: 'mark'
        expect(users.map(&:username)).to eq ['mark']
      end
    end

    it 'after reindex a user is still found' do
      as(current_user) do |pavlov|
        create :full_user, username: 'mark'

        pavlov.interactor :'full_text_search/reindex'

        users = pavlov.interactor :search_user, keywords: 'mark'
        expect(users.map(&:username)).to eq ['mark']
      end
    end
  end
end
