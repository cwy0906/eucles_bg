class ExchangeRateMonitor < ApplicationRecord

  enum currency:     { usd:  0, jpy: 1 }
  enum alert_type:   { telegram: 0 }
  enum status:       { pending: 0, in_progress: 1, completed: 2, paused:3, failed: 4 }

  belongs_to :user

end
