class AdminController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    authorize! :manage, :all

    @users = User.order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    @kids = Kid.order(created_at: :desc)
  end

end
