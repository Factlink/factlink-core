class FactIdInteger < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE fact_data ALTER COLUMN fact_id TYPE integer USING (fact_id::integer)'
  end

  def down
    execute 'ALTER TABLE fact_data ALTER COLUMN fact_id TYPE text USING (fact_id::text)'
  end
end
