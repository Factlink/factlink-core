# Suggesties:
# maak er object ip class aan, met:
# def self.perform(*args); new(*args).perform; end
# maakt beter testbaar en code simpeler

# maak losse query/functie om voor de factrelation de
# timestamp op te halen,  die wil je het hardst testen

# zorg dat als de fact_relation al een created_at heeft dat je eraf blijft
# (ding draait immers async)

class AddTimestampsToFactrelation

  @queue = :fact_relation_operations

  attr_reader :fact_relation

  def initialize(fact_relation_id)
    @fact_relation = FactRelation[fact_relation_id]
  end

  def perform
    if fact_relation
      fact_relation.created_at = timestamp
      fact_relation.save
    end
  end

  def timestamp
    @timestamp ||= calculate_timestamp
  end

  def calculate_timestamp
    ActivityTimestamp.new(fact_relation).timestamp ||
      FactsTimestamp.new(fact_relation).timestamp ||
      Time.now.utc.to_s
  end

  def self.perform(fact_relation_id)
    new(fact_relation_id).perform
  end


  class ActivityTimestamp

    attr_reader :fact_relation

    def initialize fact_relation
      @fact_relation = fact_relation
    end

    def timestamp
      return nil unless activity

      activity.created_at
    end

    def activity
      @activity ||= Activity.find(subject_id: fact_relation.id,
                      subject_class: fact_relation.class,
                      action: activity_type).first
    end

    def activity_type
      if [:supporting, "supporting"].include? fact_relation.type
        :added_supporting_evidence
      else
        :added_weakening_evidence
      end
    end
  end


  class FactsTimestamp

    attr_reader :fact_relation

    def initialize fact_relation
      @fact_relation = fact_relation
    end

    def timestamp
      time = Time.parse max_timestamp
      (time + 1).utc.to_s
    end

    def max_timestamp
      [fact_relation.fact.created_at, fact_relation.from_fact.created_at].compact.max
    end
  end
end
