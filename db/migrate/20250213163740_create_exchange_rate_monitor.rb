class CreateExchangeRateMonitor < ActiveRecord::Migration[7.1]
  def change
    create_table :exchange_rate_monitors do |t|
      t.string     :creator_id,        null: false
      t.string     :bank_name,         null: false
      t.integer    :currency,          null: false
      t.decimal    :target_rate,       null: false,  precision: 7, scale: 4
      t.decimal    :rate_at_setting,   precision: 7, scale: 4
      t.integer    :alert_type,        default: 0
      t.text       :message_content
      t.string     :note
      t.datetime   :last_scan_datetime
      t.datetime   :expiration_datetime
      t.integer    :status,            default: 0
      t.timestamps

      t.index :bank_name
      t.index :creator_id
      t.index :currency
      t.index :expiration_datetime
    end
  end
end
