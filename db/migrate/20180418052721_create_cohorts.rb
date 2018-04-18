class CreateCohorts < ActiveRecord::Migration[5.1]
  def change
    create_table :cohorts do |t|
      t.datetime :start, null: false
      t.datetime :end, null: false
      t.integer :users, default: 0, null: false
      t.index [:start, :end], unique: true
      t.timestamps
    end
  end
end
