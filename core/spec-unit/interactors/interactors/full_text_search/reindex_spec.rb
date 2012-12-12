require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/full_text_search/reindex.rb'

describe Interactors::FullTextSearch::Reindex do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch'
  end

  it '.execute' do
    interactor = Interactors::FullTextSearch::Reindex.new

    interactor.should_receive(:reset_mapping)
    interactor.should_receive(:reindex)

    interactor.execute
  end

  it '.reset_mapping' do
    interactor = Interactors::FullTextSearch::Reindex.new

    ElasticSearch.should_receive(:clean)
    ElasticSearch.should_receive(:create)

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

      fact_data_1 = stub(id: '11aa')
      fact_data_2 = stub(id: '22bb')

      fact_data_list = [fact_data_1, fact_data_2]

      FactData.should_receive(:all).and_return(fact_data_list)

      fact_data_list.each do |fact_data|
        Resque.should_receive(:enqueue).with(CreateSearchIndexForFactData, fact_data.id)
      end

      interactor = Interactors::FullTextSearch::Reindex.new
      interactor.seed_fact_data
    end

    it '.seed_channels' do
      stub_classes 'Topic'
      stub_classes 'CreateSearchIndexForTopic'

      topic1 = stub(id: '33cc')
      topic2 = stub(id: '44dd')
      topics = [topic1, topic2]

      Topic.should_receive(:all).and_return(topics)

      topics.each do |topic|
        Resque.should_receive(:enqueue).with(CreateSearchIndexForTopic, topic.id)
      end

      interactor = Interactors::FullTextSearch::Reindex.new
      interactor.seed_topics
    end

    it '.seed_users' do
      stub_classes 'User'
      stub_classes 'CreateSearchIndexForUser'

      user1 = stub(id: '33cc')
      user2 = stub(id: '44dd')
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
