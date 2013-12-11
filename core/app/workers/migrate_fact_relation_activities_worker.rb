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
    if a.still_valid?
      fr = FactRelation.find(type: type, from_fact_id: a.subject.id,
        fact_id: a.object.id).first

      if fr
        a.subject = fr
        a.action = :created_fact_relation
        a.save!
      else
        a.delete
      end
    else
      a.delete
    end
  end
end
