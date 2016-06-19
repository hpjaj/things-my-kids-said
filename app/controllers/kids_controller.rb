class KidsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @kids = current_user.kids.order(:first_name)
  end

  def new
    authorize! :create, Kid

    @kid = Kid.new
  end

  def create
    if current_user.kids.create(kid_params)
      redirect_to kids_path
    else
      flash[:error] = "There was a problem creating your kid's profile.  Please try again."
      render :new
    end
  end

  def edit
    @kid = Kid.find(params[:id])

    authorize! :update, @kid
  end

  def update
    @kid = Kid.find(params[:id])

    authorize! :update, @kid

    if @kid.update(kid_params)
      redirect_to kids_path
    else
      flash[:error] = "There was a problem updating your kid.  Please try again."
      render :edit
    end
  end

  def destroy
    @kid = Kid.find(params[:id])

    authorize! :destroy, @kid

    if @kid.delete
      flash[:notice] = 'Your kid was successfully deleted.'
      redirect_to kids_path
    else
      flash[:error] = 'There was a problem deleting your kid. Please try again.'
      render :index
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :birthdate, :gender, :photo, :created_by)
  end
  end

end
