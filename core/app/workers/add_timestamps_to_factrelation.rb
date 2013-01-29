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

  def self.perform(fact_relation_id)
    fact_relation = FactRelation[fact_relation_id]

    if fact_relation
      activity = activity_for_fact_relation fact_relation

      if activity
        fact_relation.created_at = activity.created_at
        fact_relation.updated_at = activity.created_at
        fact_relation.save
      end
    end
  end

  def self.activity_for_fact_relation fact_relation
    action = activity_type fact_relation
    Activity.find(subject_id: fact_relation.id, subject_class: fact_relation.class, action: action).first
  end

  def self.activity_type fact_relation
    if fact_relation.type == (:supporting || "supporting")
      action = :added_supporting_evidence
    else
      action = :added_weakening_evidence
    end

    action
  end

end
