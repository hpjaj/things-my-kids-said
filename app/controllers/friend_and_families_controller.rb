class FriendAndFamiliesController < ApplicationController

  before_action :authenticate_user!

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
      flash[:error] = 'There was a problem saving the new access.  Please try again.'
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
      flash[:error] = 'There was a problem saving this access.  Please try again.'
      render :edit
    end
  end

  def destroy
    @friend_and_family = FriendAndFamily.find(params[:id])

    if @friend_and_family.destroy
      flash[:notice] = "This friend/family member's access has been successfully deleted."
      redirect_to friend_and_families_path
    else
      flash[:error] = "There was a problem deleting this friend/family member's access. Please try again."
      redirect_to friend_and_families_path
    end
  end

  private

  def friend_and_family_params
    params.require(:friend_and_family).permit(:kid_id, :follower_id, :can_create_posts, :relationship_name)
  end

end
