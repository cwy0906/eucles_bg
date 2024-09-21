class BackstageController < ApplicationController

  before_action :identity_authorize, :add_operation_tag

  def index
  end

end
