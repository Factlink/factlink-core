require 'spec_helper'

describe 'full text search' do
  include PavlovSupport
  let(:current_user) { create :user }

  before do
    ElasticSearch.stub synchronous: true
  end

  def create_user name
    u = User.new(
      username: name,
      password: 'password',
      password_confirmation: 'password',
      first_name: name,
      last_name: name)
    u.approved = true
    u.agrees_tos = true
    u.agreed_tos_on = DateTime.now
    u.email = "#{name}@#{name}.com"
    u.confirmed_at = DateTime.now
    u.save or fail "oh noes"
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
        create_user('mark')

        users = pavlov.interactor :search_user, keywords: 'mark'
        expect(users.map(&:username)).to eq ['mark']
      end
    end

    it 'after reindex a user is still found' do
      as(current_user) do |pavlov|
        create_user('mark')

        pavlov.interactor :'full_text_search/reindex'

        users = pavlov.interactor :search_user, keywords: 'mark'
        expect(users.map(&:username)).to eq ['mark']
      end
    end
  end
end
