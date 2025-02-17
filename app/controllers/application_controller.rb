class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :clear_optional_session_data
  before_action :identity_authorize
  before_action :add_operation_main_tag



  def current_user
    if session[:core].present? && session[:core]['user_id'].present?
      @current_user = User.find(session[:core]['user_id'])
    else 
      @current_user = nil
    end
  end

  def identity_authorize
    if current_user.nil?
      session[:option]['common_message'] = { title: "Notice", content: "Input user id & pw for logging." }
      redirect_to login_path
    end
  end

  def role_authorize
  end

  def clear_optional_session_data
    session[:option] = {}
  end

  def add_operation_main_tag
    session[:option]['operation_main_tag'] = controller_name
  end

end
