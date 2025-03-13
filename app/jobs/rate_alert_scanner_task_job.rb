class RateAlertScannerTaskJob < ApplicationJob
  queue_as :default

  def perform(*args)
    check_monitors = ExchangeRateMonitor.where(status:0)
    current_currency_hash = bot_instantly_exchange_rate_hash
 
    usd_check_monitors = check_monitors.where(currency:'usd')
    usd_check_monitors.each do |monitor|
      check_target_rate  = BigDecimal(monitor.target_rate)
      check_rate_type    = monitor.rate_type
      check_current_rate = current_currency_hash["usd"][check_rate_type]
      case monitor.alert_type
      when "less"
        if (check_current_rate <= check_target_rate)
          messenge = "Current currency usd rate #{check_current_rate} is less than your setting target_rate #{check_target_rate} !"
          monitor.update(status:2)
          send_telegram_messenge_to_group(messenge)
        end
      when "greater"
        if (check_current_rate >= check_target_rate)
          messenge = "Current currency usd rate #{check_current_rate} is greater than your setting target_rate #{check_target_rate} !"
          monitor.update(status:2)
          send_telegram_messenge_to_group(messenge)
        end
      end
    end
    
    jpy_check_monitors = check_monitors.where(currency:'jpy')
    jpy_check_monitors.each do |monitor|
      check_target_rate  = BigDecimal(monitor.target_rate)
      check_rate_type    = monitor.rate_type
      check_current_rate = current_currency_hash["jpy"][check_rate_type]
      case monitor.alert_type
      when "less"
        if (check_current_rate <= check_target_rate)
          messenge = "Current currency jpy rate #{check_current_rate} is less than your setting target_rate #{check_target_rate} !"
          monitor.update(status:2)
          send_telegram_messenge_to_group(messenge)
        end
      when "greater"
        if (check_current_rate >= check_target_rate)
          messenge = "Current currency jpy rate #{check_current_rate} is greater than your setting target_rate #{check_target_rate} !"
          monitor.update(status:2)
          send_telegram_messenge_to_group(messenge)
        end
      end
    end

  end

  private 
  def bot_instantly_exchange_rate_hash
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
          sub_hash["cash_buying"] = BigDecimal(currency_data.at_css('td[data-table="Cash Buying"]').text.strip)
          sub_hash["cash_selling"] = BigDecimal(currency_data.at_css('td[data-table="Cash Selling"]').text.strip)
          sub_hash["spot_buying"] = BigDecimal(currency_data.at_css('td[data-table="Spot Buying"]').text.strip)
          sub_hash["spot_selling"] = BigDecimal(currency_data.at_css('td[data-table="Spot Selling"]').text.strip)
          currencies_info_hash[currency_tag[-4..-2].downcase] = sub_hash
      end
    end
    currencies_info_hash
  end 

  def send_telegram_messenge_to_group(messenge)
    service = ExternalMessengerService.new
    service.send_normal_messenge(messenge)
  end
end
