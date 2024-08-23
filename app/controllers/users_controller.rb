class UsersController < ApplicationController
  before_action :user_params, only: [:create]

  def index
    @show_users = User.all
  end

  def new
  end

  def create
    @reserve_user    = User.new(user_params)
    @reserve_user.id = SecureRandom.hex(16)
    @common_message  = CommonMessage.new(title: "Create new user result :")
    
    if @reserve_user.save
      @common_message.tag     = "info"
      @common_message.content = "success"
    else
      @common_message.tag     = "warning"
      @common_message.content = "failed"
    end

    render :new
  end

  private
  def user_params
    params[:role] = params[:role].to_i
    params.permit(:email, :user_name, :nickname, :password, :role)
  end

end