class AddForeignKeyToRateMonitor < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :exchange_rate_monitors, :users, column: :creator_id, primary_key: :id_hash
  end
end
