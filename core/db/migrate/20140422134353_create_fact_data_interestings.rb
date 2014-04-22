class CreateFactDataInterestings < ActiveRecord::Migration
  def change
    create_table :fact_data_interestings do |t|
      t.integer :fact_data_id
      t.integer :user_id

      t.timestamps
    end
  end
end
