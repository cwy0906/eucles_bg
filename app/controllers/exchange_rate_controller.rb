class ExchangeRateController < ApplicationController
  before_action :add_operation_sub_tag

  def index
    bank_name = params[:bank_name]
    session[:option]['common_message'] ||= { title: "Notice", content: "Welcome to exchange rate index page. #{bank_name}" }
    
  end

  def update_jpy_chart
    bank_name = params[:bank_name]
    period    = params[:period]
    render json: query_jpy_historical_rates(bank_name, period)
  end

  def update_usd_chart
    bank_name = params[:bank_name]
    period    = params[:period]
    render json: query_usd_historical_rates(bank_name, period)
  end

  def schedule_inquiry
    bank_name    = params[:bank_name]
    user_id_hash = params[:user_id_hash]

    monitors = ExchangeRateMonitor.where(creator_id: user_id_hash)
    monitors.each do |monitor|
      case monitor.currency
      when 'usd'
        current_rate = bot_instantly_exchange_rate_hash['usd']['spot_buying']
        monitor.update(rate_at_setting: current_rate)
      when 'jpy'
        current_rate = bot_instantly_exchange_rate_hash['jpy']['cash_selling']
        monitor.update(rate_at_setting: current_rate)
      end
    end

    render json: monitors.as_json
  end

  def schedule_update
    schedule_id              = params[:schedule_id]
    schedule_target_rate     = params[:schedule_target_rate]
    schedule_message_content = params[:schedule_message_content]
    schedule_alert_type      = params[:schedule_alert_type] == 'less' ? 0 : 1 


    if params[:schedule_status].present?
      schedule_status = params[:schedule_status] == "on" ? "pending" : "paused"
    else
      schedule_status = nil
    end

    update_hash = {target_rate: schedule_target_rate, message_content: schedule_message_content, status: schedule_status, alert_type: schedule_alert_type} 
    update_hash = update_hash.select {|key, value| value.present? }
    
    if ExchangeRateMonitor.find(schedule_id).update!(update_hash)
      render json: { message: "status updated successfully."}, status: :ok
    else
      render json: { message: "status update failed."}, status: :error
    end
  end 

  private
  def query_jpy_historical_rates(bank_name ,period = '6m')
    historical_rate_class = "#{bank_name.capitalize}HistoricalExchangeRate".constantize
    jpy_query_end_date   = historical_rate_class.where(currency:'jpy').maximum(:recorded_date)
    case period
    when '6m'
      jpy_query_start_date  = jpy_query_end_date - 6.months
      session[:option]['jpy_query_period_btn']      = '6m'
    when '3m'
      jpy_query_start_date  = jpy_query_end_date - 3.months
      session[:option]['jpy_query_period_btn']      = '3m'
    when '1w'
      jpy_query_start_date  = jpy_query_end_date - 1.week
      session[:option]['jpy_query_period_btn']      = '1w'
    else 
      jpy_query_start_date  = jpy_query_end_date - 6.months
      session[:option]['jpy_query_period_btn']      = '6m'
    end

    jpy_query_rates_data  = historical_rate_class.where(currency:'jpy').where(recorded_date: jpy_query_start_date..jpy_query_end_date)
    jpy_query_rates_array = jpy_query_rates_data.pluck(:recorded_date, :cash_selling_rate)
    jpy_query_mean_rate   = jpy_query_rates_data.average(:cash_selling_rate).round(4)

    {"jpy_query_date":{"start": jpy_query_start_date.to_s ,"end": jpy_query_end_date.to_s},
    "recent_period_jpy_rate_result":{"mean_rate": jpy_query_mean_rate,"historical_rate": jpy_query_rates_array}}
    
  end

  def query_usd_historical_rates(bank_name ,period = '6m')
    historical_rate_class = "#{bank_name.capitalize}HistoricalExchangeRate".constantize
    usd_query_end_date   = historical_rate_class.where(currency:'usd').maximum(:recorded_date)
    case period
    when '6m'
      usd_query_start_date  = usd_query_end_date - 6.months
      session[:option]['usd_query_period_btn']      = '6m'
    when '3m'
      usd_query_start_date  = usd_query_end_date - 3.months
      session[:option]['usd_query_period_btn']      = '3m'
    when '1w'
      usd_query_start_date  = usd_query_end_date - 1.week
      session[:option]['usd_query_period_btn']      = '1w'
    else 
      usd_query_start_date  = usd_query_end_date - 6.months
      session[:option]['usd_query_period_btn']      = '6m'
    end

    usd_query_rates_data  = historical_rate_class.where(currency:'usd').where(recorded_date: usd_query_start_date..usd_query_end_date)
    usd_query_rates_array = usd_query_rates_data.pluck(:recorded_date, :spot_buying_rate)
    usd_query_mean_rate   = usd_query_rates_data.average(:spot_buying_rate).round(4)

    {"usd_query_date":{"start": usd_query_start_date.to_s ,"end": usd_query_end_date.to_s},
    "recent_period_usd_rate_result":{"mean_rate": usd_query_mean_rate,"historical_rate": usd_query_rates_array}}
    
  end

  def add_operation_sub_tag
    session[:option]['operation_sub_tag'] = 'bot'
  end

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

end