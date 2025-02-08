class ExchangeRateController < ApplicationController
  
  def index
    bank_name = params[:bank_name]
    session[:common_message] ||= { title: "Notice", content: "Welcome to exchange rate index page. #{bank_name}" }

    session[:operation_sub_tag] = 'BOT'
  end


end