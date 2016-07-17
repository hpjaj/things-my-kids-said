class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filtered_kids = Kid.filtered_out_by(current_user).sort_by_last_name
  end
end
