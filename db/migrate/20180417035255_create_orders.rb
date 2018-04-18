class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user
      t.integer :order_num, default: 0, null: false
      t.index [:user_id, :order_num]
      t.timestamps
    end
  end
end
