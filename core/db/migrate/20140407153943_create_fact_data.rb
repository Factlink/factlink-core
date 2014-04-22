class CreateFactData < ActiveRecord::Migration
  def change
    create_table :fact_data do |t|
      t.text :title
      t.text :displaystring
      t.text :site_url
      t.string :fact_id

      t.timestamps
    end
  end
end
