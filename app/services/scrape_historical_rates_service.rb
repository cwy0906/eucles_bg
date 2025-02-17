
class ScrapeHistoricalRatesService

  def initialize
  end

  def execute_six_months_query(bank_name, currency)
    source_path = AppConfig.web_crawler.send("#{bank_name}_source").send("#{currency}_last_six_months_rates_path")
    historical_rate_class = "#{bank_name.capitalize}HistoricalExchangeRate".constantize
    currency_code = historical_rate_class.currencies[currency]
    last_updated  = historical_rate_class.where(currency: currency_code).maximum(:recorded_date).to_s
    last_updated  = '2024/06/30' unless last_updated.present?
      
    response      = Faraday.get(source_path).body
    html_data     = Nokogiri::HTML(response)
    period_info    = html_data.css('div.span4 div.chart-key-value div.value').text.strip.split
    rate_infos       = html_data.css('tbody tr')
    rate_infos_array = []
     
    rate_infos.each do |rate_info|
      rate_info_date = rate_info.at_css('td:nth-child(1)').text.strip
      if (Date.parse(rate_info_date) > Date.parse(last_updated)) 
        rate_infos_array << {
          recorded_date: rate_info_date,
          currency: currency_code,
          cash_buying_rate: rate_info.at_css('td:nth-child(3)').text.strip,
          cash_selling_rate: rate_info.at_css('td:nth-child(4)').text.strip,
          spot_buying_rate: rate_info.at_css('td:nth-child(5)').text.strip,
          spot_selling_rate: rate_info.at_css('td:nth-child(6)').text.strip
        }
      end
    end
    historical_rate_class.import rate_infos_array

  end

end