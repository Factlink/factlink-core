class FixSearch < ActiveRecord::Migration
  def up
    FactData.all.each do |fact_data|
      PgSearch::Multisearch.rebuild(Product)
    end

    User.all.each do |user|
      PgSearch::Multisearch.rebuild(Product)
    end
  end
end
