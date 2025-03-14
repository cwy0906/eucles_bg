class UserSessionsController < ApplicationController

  layout 'entrance'
  skip_before_action :identity_authorize, only: [:index, :create]

  def index
  end

  def create
    request_email    = create_sessions_params[:email].downcase
    request_password = create_sessions_params[:password]
    tbc_user         = User.find_by(email: request_email)&.authenticate(request_password)

    if tbc_user.present?
      session[:core] = {'user_id' => tbc_user.id_hash}
      session[:option]['common_message'] = { title: "Notice", content: "Welcome to index page, #{tbc_user.nickname}" }
      redirect_to root_path
    else
      session[:option]['common_message'] = { title: "Alert", content: "No such user by this email & pw." }
      render :index
    end
  end

  def destroy
    session.delete(:core)
    session[:option]['common_message'] = { title: "Notice", content: "Logged out!" }
    redirect_to login_path
  end

  private
  def create_sessions_params
    params.permit(:email, :password)
  end

end
