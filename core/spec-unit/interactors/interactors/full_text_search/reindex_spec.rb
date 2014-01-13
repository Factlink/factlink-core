require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/full_text_search/reindex.rb'

describe Interactors::FullTextSearch::Reindex do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch'
  end

  it '.call' do
    interactor = Interactors::FullTextSearch::Reindex.new

    interactor.should_receive(:reset_mapping)
    interactor.should_receive(:reindex)

    interactor.call
  end

  it '.reset_mapping' do
    interactor = Interactors::FullTextSearch::Reindex.new

    ElasticSearch.should_receive(:truncate)

    interactor.reset_mapping
  end

  it '.reindex' do
    interactor = Interactors::FullTextSearch::Reindex.new

    interactor.should_receive(:seed_fact_data)
    interactor.should_receive(:seed_topics)
    interactor.should_receive(:seed_users)

    interactor.reindex
  end


  describe 'seeding data' do

    before do
      stub_classes 'Resque'
    end

    it '.seed_fact_data' do
      stub_classes 'FactData'
      stub_classes 'CreateSearchIndexForFactData'

      fact_data_1 = double(id: '11aa')
      fact_data_2 = double(id: '22bb')

      fact_data_list = [fact_data_1, fact_data_2]

      FactData.should_receive(:all).and_return(fact_data_list)

      fact_data_list.each do |fact_data|
        Resque.should_receive(:enqueue).with(CreateSearchIndexForFactData, fact_data.id)
      end

      interactor = Interactors::FullTextSearch::Reindex.new
      interactor.seed_fact_data
    end

    it '.seed_users' do
      stub_classes 'User'
      stub_classes 'CreateSearchIndexForUser'

      user1 = double(id: '33cc')
      user2 = double(id: '44dd')
      users = [user1, user2]

      User.should_receive(:all).and_return(users)

      users.each do |user|
        Resque.should_receive(:enqueue).with(CreateSearchIndexForUser, user.id)
      end

      interactor = Interactors::FullTextSearch::Reindex.new
      interactor.seed_users
    end

  end

end
