class FriendAndFamiliesController < ApplicationController

  def index
    @friends_and_families = FriendAndFamily.parents_kids_friends_and_family(current_user)
  end

  def new
    @friend_and_family = FriendAndFamily.new
  end

  def create
    @friend_and_family = FriendAndFamily.new(friend_and_family_params)

    if @friend_and_family.save
      redirect_to friend_and_families_path
    else
      flash[:error] = 'There was a problem saving your new permission.  Please try again.'
      render :new
    end
  end

  def edit
    @friend_and_family = FriendAndFamily.find(params[:id])
  end

  def update
    @friend_and_family = FriendAndFamily.find(params[:id])

    if @friend_and_family.update(friend_and_family_params)
      redirect_to friend_and_families_path
    else
      flash[:error] = 'There was a problem saving your permission.  Please try again.'
      render :edit
    end
  end

  def destroy
    @friend_and_family = FriendAndFamily.find(params[:id])

    if @friend_and_family.delete
      flash[:notice] = 'Your friend/family member permission has been successfully deleted.'
      redirect_to friend_and_families_path
    else
      flash[:error] = "There was a problem deleting your friend/family member's permission. Please try again."
      redirect_to friend_and_families_path
    end
  end

  private

  def friend_and_family_params
    params.require(:friend_and_family).permit(:kid_id, :follower_id, :can_create_posts)
  end

end
