class MigrateFactRelationActivitiesWorker
  @queue = :aaa_migration

  def self.perform
    Activity.find(action: :added_supporting_evidence).each do |a|
      migrate_activity a, 'supporting'
    end

    Activity.find(action: :added_weakening_evidence).each do |a|
      migrate_activity a, 'weakening'
    end
  end

  def self.migrate_activity a, type
    fr = FactRelation.find(type: type, from_fact_id: a.subject.id,
      fact_id: a.object.id).first

    fail 'No fact relation found for activity ' + a.id unless fr

    a.subject = fr
    a.action = :created_fact_relation
    a.save!
  end
end
