class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filtered_kids = FilteredKid.sorted_kids_of(current_user)
  end
end
