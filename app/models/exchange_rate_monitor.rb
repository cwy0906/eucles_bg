class ExchangeRateMonitor < ApplicationRecord

  enum currency:     { usd:  0, jpy: 1 }
  enum rate_type:    { cash_buying: 0, cash_selling: 1, spot_buying: 2, spot_selling: 3,}
  enum alert_type:   { telegram: 0 }
  enum status:       { pending: 0, completed: 1, paused:2, failed: 3 }

  belongs_to :user, foreign_key: 'creator_id', primary_key: 'id_hash'

end
