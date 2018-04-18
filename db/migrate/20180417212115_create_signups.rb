class CreateSignups < ActiveRecord::Migration[5.1]
  def change
    create_table :signups do |t|
      t.bigint :user_id, index: true, unique: true, null: false
      t.datetime :signup_date, null: false
    end
  end
end
