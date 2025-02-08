class ExchangeRateController < ApplicationController
  
  after_action :clear_common_message

  
  def index
    Rails.logger.warn "PASS HERE !!!!!!!"
    bank_name = params[:bank_name]
    session[:common_message] ||= { title: "Notice", content: "Welcome to exchange rate index page. #{bank_name}" }

    session[:operation_sub_tag] = params[:bank_name]
  end

end