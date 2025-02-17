class BotHistoricalExchangeRate < ApplicationRecord
  enum currency:     { usd:  0, jpy: 1 }
end
