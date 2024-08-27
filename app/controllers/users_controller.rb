class UsersController < ApplicationController

  def index
    @show_users = User.all
  end

  def new
  end

  def create
    @reserve_user    = User.new(create_user_params)
    @reserve_user.id = SecureRandom.hex(16)
    
    @reserve_user.save

    redirect_to users_path
  end

  def destroy
    user_id_hash = delete_user_params[:id]
    chose_user   = User.find_by(id_hash: user_id_hash)

    User.find(user_id_hash).destroy

    redirect_to users_path
  end

  private
  def create_user_params
    params[:role] = params[:role].to_i
    params.permit(:email, :user_name, :nickname, :password, :role)
  end

  def delete_user_params
    params.permit(:id, :_method)
  end

end