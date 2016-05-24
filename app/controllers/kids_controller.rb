class KidsController < ApplicationController
  load_and_authorize_resource

  def index
    @kids = current_user.kids
  end

  def new
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
  end

  def update
    @kid = Kid.find(params[:id])

    if @kid.update(kid_params)
      redirect_to kids_path
    else
      flash[:error] = "There was a problem updating your kid.  Please try again."
      render :edit
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :birthdate, :gender, :photo)
  end

end
