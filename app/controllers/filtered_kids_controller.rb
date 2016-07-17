class FilteredKidsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filtered_kids = FilteredKid.sorted_kids_of(current_user)
  end

  def new
    @filtered_kid = FilteredKid.new
  end

  def create
    authorize! :create, FilteredKid

    @filtered_kid = current_user.filtered_kids.build(filtered_kid_params)

    if @filtered_kid.save
      redirect_to settings_path
    else
      flash[:error] = 'There was a problem hiding this kid.  Please try again.'
      render :new
    end
  end

  def destroy
    @filtered_kid = FilteredKid.find(params[:id])

    authorize! :destroy, @filtered_kid

    if @filtered_kid.destroy
      flash[:notice] = "#{@filtered_kid.kid.full_name}'s quotes will now be shown in your timeline."
    else
      flash[:error] = 'There was a problem showing this kid. Please try again.'
    end

    redirect_to settings_path
  end

  private

  def filtered_kid_params
    params.require(:filtered_kid).permit(:user_id, :kid_id)
  end

end
