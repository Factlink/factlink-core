class InterestingToSql < ActiveRecord::Migration
  def up
    FactData.all.each do |fact_data|
      believes_ids = Nest.new("Fact:#{fact_data.fact_id}:people_believes").smembers
      disbelieves_ids = Nest.new("Fact:#{fact_data.fact_id}:people_disbelieves").smembers

      (believes_ids + disbelieves_ids).each do |user_id|
        Backend::Facts.set_interesting fact_id: fact_data.fact_id, user_id: user_id
      end
    end
  end

  def down
  end
end
