class CreateFactDataInterestings < ActiveRecord::Migration
  def change
    create_table :fact_data_interestings do |t|
      t.integer :fact_data_id
      t.integer :user_id

      t.timestamps
    end

    add_index :fact_data_interestings, :fact_data_id
    add_index :fact_data_interestings, :user_id
  end
end
