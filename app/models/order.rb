class Order < ApplicationRecord
  require 'csv'

  belongs_to :user

  def self.import(file)
    CSV.foreach(file, headers: true) do |row|
      row_hash = row.to_hash
      if !User.exists?(row_hash['user_id'])
        User.create!(id: row_hash['user_id'],
                     created_at: row_hash['created_at'],
                     updated_at: row_hash['updated_at'])
      end
      Order.create!(row_hash)
    end
  end
end
