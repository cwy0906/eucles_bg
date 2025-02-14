class CreateBotHistoricalExchangeRates < ActiveRecord::Migration[7.1]
  def change
    create_table :bot_historical_exchange_rates do |t|
      t.date    :recorded_date,  null: false
      t.integer :currency,       null: false
      t.decimal :exchange_rate,  null: false, precision: 7, scale: 4
      t.timestamps

      t.index :recorded_date
      t.index :currency
    end
  end
end
