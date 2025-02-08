# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(user, main_tag, sub_tag)
    @current_user       = user
    @operation_main_tag = main_tag
    @operation_sub_tag  = sub_tag
  end

  def root_path
    helpers.root_path(@current_user)
  end

  def eucles_logo_path
    helpers.asset_path('eucles_logo.png')
  end

  def user_avatar_path
    @current_user.root? ? helpers.asset_path('kabuto.png') : helpers.asset_path('gasa.png')
  end

  def user_nickname
    @current_user.nickname
  end

  def logout_path
    helpers.logout_path
  end

  def users_icon_status
    @operation_main_tag == "users" ? "bi-people-fill" : "bi-people"
  end

end
