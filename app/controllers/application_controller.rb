class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :identity_authorize
  before_action :add_operation_main_tag, :add_operation_sub_tag

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def identity_authorize
    if current_user.nil? 
      session[:common_message] = { title: "Notice", content: "Input user id & pw for logging." }
      redirect_to login_path
    end
  end

  def role_authorize
  end

  def clear_common_message
    session[:common_message] = nil
  end

  def add_operation_main_tag
    controller_name == 'backstage' ? session[:operation_main_tag] = nil : session[:operation_main_tag] = controller_name
  end

  def add_operation_sub_tag
    session[:operation_sub_tag] = nil
  end

end
