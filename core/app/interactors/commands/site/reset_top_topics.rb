require_relative './common_functionality.rb'

module Commands
  module Site
    class ResetTopTopics
      include Pavlov::Command
      include CommonFunctionality

      arguments :site_id

      def execute
        clear_topics

        scores.each do |topic_slug, score|
          increase_topic_by topic_slug, score
        end
      end

      def clear_topics
        key.del
      end

      def scores
        scores = facts.map {|f| scores_for_fact f}
        sum_hashes scores
      end

      def facts
        Fact.find(site_id: @site_id)
      end

      def scores_for_fact fact
        slugs = slugs_for_fact fact
        score_hash_for_array slugs
      end

      def slugs_for_fact fact
        fact.channels.map(&:slug_title)
      end

      def score_hash_for_array array
        hash = Hash.new 0
        array.map { |e| hash[e] += 1 }
        hash
      end

      def sum_hashes hashes
        summed_hash = Hash.new 0
        hashes.each do |hash|
          hash.each do |key, value|
            summed_hash[key] += value
          end
        end
        summed_hash
      end

      def validate
        validate_integer :site_id, @site_id
      end
    end
  end
end

