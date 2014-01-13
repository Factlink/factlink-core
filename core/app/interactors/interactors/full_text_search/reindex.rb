require_relative '../../../classes/elastic_search.rb'

# This one interactor isn't used much, but we keep it around
# for in migrations.
module Interactors
  module FullTextSearch
    class Reindex
      include Pavlov::Interactor

      def execute
        reset_mapping
        reindex
      end

      def reset_mapping
        ElasticSearch.truncate
      end

      def reindex
        seed_fact_data
        seed_users
      end

      def seed_fact_data
        FactData.all.each do |fact_data|
          Resque.enqueue(CreateSearchIndexForFactData, fact_data.id)
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
