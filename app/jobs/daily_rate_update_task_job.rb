class DailyRateUpdateTaskJob < ApplicationJob
  queue_as :default

  def perform(*args)
    service = ScrapeHistoricalRatesService.new
    service.execute_six_months_query('bot','jpy')
    service.execute_six_months_query('bot','usd')
  end
end
