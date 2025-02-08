# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(user, main_tag, sub_tag)
    @current_user       = user
    @operation_main_tag = main_tag
    @operation_sub_tag  = sub_tag
  end

  def site_info
    {root_path: helpers.root_path(@current_user), logo_path: helpers.asset_path('eucles_logo.png')}
  end

  def user_info
    info_data = { nickname: @current_user.nickname,  logout_path: helpers.logout_path}

    if @current_user.root?
      info_data[:avatar_path] = helpers.asset_path('kabuto.png')
    else
      info_data[:avatar_path] = helpers.asset_path('gasa.png')
    end
    info_data
  end

  def users_item_status
    info_data = {path: helpers.users_path}
    if @operation_main_tag == "users"
      info_data[:main_tag] = "bi-people-fill"
    else
      info_data[:main_tag] = "bi-people"
    end
    info_data
  end

  def fx_rate_item_status
    info_data   = { bank_link: {bot: "/exchange_rate/bot/index"}}
    if @operation_main_tag == "exchange_rate"
      info_data[:main_tag] = {open:"show",mark:""}
    else
      info_data[:main_tag] = {open:"",mark:"collapsed"}
    end

    if @operation_sub_tag  == "BOT"
      info_data[:sub_tag] = "active"
    else
      info_data[:sub_tag] = ""
    end
    info_data
  end


end
