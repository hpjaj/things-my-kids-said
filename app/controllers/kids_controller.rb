class KidsController < ApplicationController

  def index
  end

  def new
    @kid = current_user.kids.build
  end

  def create
    if current_user.kids.create(kid_params)
      redirect_to root_path
    else
      flash[:error] = "There was a problem creating your kid's profile.  Please try again."
      render :new
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:name, :birthdate, :gender)
  end

end
