class MigrateSupportingWeakeningFactRelationWorker
  @queue = :aaa_migration

  def self.perform
    FactRelation.find(type: :supporting).each do |fr|
      fr.type = :believes
      fr.save!
    end
    FactRelation.find(type: :weakening).each do |fr|
      fr.type = :disbelieves
      fr.save!
    end
  end
end
