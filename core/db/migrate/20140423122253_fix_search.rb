class FixSearch < ActiveRecord::Migration
  def up
    PgSearch::Multisearch.rebuild(FactData)
    PgSearch::Multisearch.rebuild(User)
  end
end
