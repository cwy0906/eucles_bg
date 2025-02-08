class BackstageController < ApplicationController

  def index
    @instantly_rate_result      = bot_instantly_exchange_rate_crawl
    @recent_day_jpy_rate_result = bot_recent_day_jpy_exchange_rate_crawl
    @recent_day_usd_rate_result = bot_recent_day_usd_exchange_rate_crawl

  end

  private
  def bot_instantly_exchange_rate_crawl
    source_path = AppConfig.web_crawler.bot_source.instantly_rate_path
    response    = Faraday.get(source_path).body
    html_data   = Nokogiri::HTML(response)
    
    head_info       = html_data.at_css('h1.hero__header span#h1_id span.hidden-phone').text.strip
    note_info       = html_data.at_css('p.text-info').text.strip
    currencies_data = html_data.css('tbody tr')
        
    currencies_info_hash = {}
    currencies_data.each do |currency_data|
      currency_tag = currency_data.at_css('td.currency.phone-small-font > div > div.visible-phone.print_hide').text.strip
        if ["American Dollar (USD)", "Japanese Yen (JPY)"].include?(currency_tag)
          sub_hash = {}
          sub_hash["cash_buying"] = currency_data.at_css('td[data-table="Cash Buying"]').text.strip
          sub_hash["cash_selling"] = currency_data.at_css('td[data-table="Cash Selling"]').text.strip
          sub_hash["spot_buying"] = currency_data.at_css('td[data-table="Spot Buying"]').text.strip
          sub_hash["spot_selling"] = currency_data.at_css('td[data-table="Spot Selling"]').text.strip
          currencies_info_hash[currency_tag] = sub_hash
      end
    end

    {
      head_info: head_info,
      note_info: note_info,
      rate_data: currencies_info_hash
    }
  end

  def bot_recent_day_jpy_exchange_rate_crawl
    source_path = AppConfig.web_crawler.bot_source.jpy_recent_day_rate_path
    response    = Faraday.get(source_path).body
    html_data   = Nokogiri::HTML(response)

    day_info         = html_data.css('div.span4 div.chart-key-value div.value').text.strip
    rate_infos       = html_data.css('tbody tr')
    rate_infos_array = []
    sum              = 0.0

    rate_infos.each do |rate_info|
      key_info   = rate_info.at_css('td:nth-child(1)').text.strip[11..20]
      value_info = rate_info.at_css('td:nth-child(4)').text.strip
      rate_infos_array << [key_info, value_info]
      sum        = sum + value_info.to_f
    end

    {
      day_info:         day_info,
      mean_rate:        (sum/rate_infos_array.size.to_f).round(4),
      historical_rate:  rate_infos_array,
    }

  end

  def bot_recent_day_usd_exchange_rate_crawl
    source_path = AppConfig.web_crawler.bot_source.usd_recent_day_rate_path
    response    = Faraday.get(source_path).body
    html_data   = Nokogiri::HTML(response)

    day_info         = html_data.css('div.span4 div.chart-key-value div.value').text.strip
    rate_infos       = html_data.css('tbody tr')
    rate_infos_array = []
    sum              = 0.0

    rate_infos.each do |rate_info|
      key_info   = rate_info.at_css('td:nth-child(1)').text.strip[11..20]
      value_info = rate_info.at_css('td:nth-child(5)').text.strip
      rate_infos_array << [key_info, value_info]
      sum        = sum + value_info.to_f
    end

    {
      day_info:         day_info,
      mean_rate:        (sum/rate_infos_array.size.to_f).round(3),
      historical_rate:  rate_infos_array,
    }
  end

end
