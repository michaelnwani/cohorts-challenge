class User < ApplicationRecord
  require 'csv'

  has_many :orders

  def self.backfill
    ActiveRecord::Base.connection.execute("TRUNCATE users RESTART IDENTITY CASCADE")
    utc_tz = ActiveSupport::TimeZone.new('UTC')
    CSV.foreach('public/users.csv', headers: true) do |row|
      row_hash = row.to_hash
      id = row_hash['id']
      created_at_tz = utc_tz.strptime(row_hash['created_at'], "%m/%d/%Y %H:%M:%S")
      updated_at_tz = utc_tz.strptime(row_hash['updated_at'], "%m/%d/%Y %H:%M:%S")
      created_at = created_at_tz.strftime("%Y-%m-%d %H:%M:%S")
      updated_at = updated_at_tz.strftime("%Y-%m-%d %H:%M:%S")

      User.create!(id: id, created_at: created_at, updated_at: updated_at)
    end
  end
end
