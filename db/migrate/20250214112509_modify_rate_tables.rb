class ModifyRateTables < ActiveRecord::Migration[7.1]
  def change
    remove_column :bot_historical_exchange_rates, :exchange_rate, :decimal

    add_column :bot_historical_exchange_rates, :cash_buying_rate, :decimal, null: false,  precision: 7, scale: 4, after: :currency 
    add_column :bot_historical_exchange_rates, :cash_selling_rate, :decimal, null: false,  precision: 7, scale: 4, after: :cash_buying_rate
    add_column :bot_historical_exchange_rates, :spot_buying_rate, :decimal, null: false,  precision: 7, scale: 4, after: :cash_selling_rate
    add_column :bot_historical_exchange_rates, :spot_selling_rate, :decimal, null: false,  precision: 7, scale: 4, after: :spot_buying_rate

    add_column :exchange_rate_monitors, :rate_type, :integer, null: false, after: :currency
  end
end
