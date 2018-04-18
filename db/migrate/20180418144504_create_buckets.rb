class CreateBuckets < ActiveRecord::Migration[5.1]
  def change
    create_table :buckets do |t|
      t.references :cohort, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.integer :orderers, null: false, default: 0
      t.integer :first_time_orderers, null: false, default: 0

      t.timestamps
    end
  end
end
