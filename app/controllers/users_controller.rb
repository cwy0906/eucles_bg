class UsersController < ApplicationController
  
  before_action :identity_authorize
  after_action  :clear_common_message, except: [:create, :destroy, :edit, :update]

  def index
    @show_users = User.all 
    session[:common_message] ||= { title: "Notice", content: "Welcome to user index page." }
  end

  def new
    session[:common_message] = { title: "Notice", content: "Input new user profile." }
  end

  def create
    @reserve_user    = User.new(create_user_params)
    @reserve_user.id = SecureRandom.hex(16)
    
    if @reserve_user.save
      session[:common_message] = { title: "Notice", content: "New user successfully created." }
    else
      session[:common_message]  = { title: "Alert", content: "Failed to create new user." }
    end

    redirect_to users_path
  end

  def edit
    user_id_hash = edit_user_params[:id]
    @edit_user   = User.find_by(id_hash: user_id_hash)
    session[:common_message] = { title: "Notice", content: "Edit user profile." }
  end

  def update
    user_id_hash = params[:id]
    update_user  = User.find_by(id_hash: user_id_hash)
    if update_user.update(update_user_params)
      session[:common_message] = { title: "Notice", content: "User successfully updated." }
    else
      session[:common_message]  = { title: "Alert", content: "Failed to update user." }
    end
    
    redirect_to users_path
  end

  def destroy
    user_id_hash = delete_user_params[:id]
    chose_user   = User.find_by(id_hash: user_id_hash)

    if User.find(user_id_hash).destroy
      session[:common_message] = { title: "Notice", content: "Chose user successfully destroyed." }
    else
      session[:common_message]  = { title: "Alert", content: "Failed to destroy chose user." }
    end

    redirect_to users_path
  end

  private
  def create_user_params
    params[:role] = params[:role].to_i
    params.permit(:email, :user_name, :nickname, :password, :role)
  end

  def edit_user_params
    params.permit(:id, :_method)
  end

  def update_user_params
    params[:role] = params[:role].to_i
    params.permit(:email, :user_name, :nickname, :password, :role)
  end

  def delete_user_params
    params.permit(:id, :_method)
  end

end