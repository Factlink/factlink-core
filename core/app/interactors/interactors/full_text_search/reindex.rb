require_relative '../../pavlov'
require_relative '../../../classes/elastic_search.rb'

module Interactors
  module FullTextSearch
    class Reindex
      include Pavlov::Interactor

      def execute
        reset_mapping
        reindex
      end

      def reset_mapping
        ElasticSearch.clean
        ElasticSearch.create
      end

      def reindex
        seed_fact_data
        seed_topics
        seed_users
      end

      def seed_fact_data
        FactData.all.each do |fact_data|
          Resque.enqueue(CreateSearchIndexForFactData, fact_data.id)
        end
      end

      def seed_topics
        Topic.all.each do |topic|
          Resque.enqueue(CreateSearchIndexForTopic, topic.id)
        end
      end

      def seed_users
        User.all.each do |user|
          Resque.enqueue(CreateSearchIndexForUser, user.id)
        end
      end

      def authorized?
        true
      end
    end
  end
end
