class PicturesController < ApplicationController

  def index
    @kid      = Kid.find(params[:kid_id])
    @pictures = Picture.for @kid
  end

  def destroy
    @picture = Picture.find(params[:id])
    kid = @picture.kid

    authorize! :destroy, @picture
    if picture_destroying_transaction
      flash[:notice] = 'Your picture was successfully removed.'
    else
      flash[:error] = 'There was a problem removing your picture. Please try again.'
    end

    if kid.pictures.present?
      redirect_to kid_pictures_path(kid)
    else
      redirect_to kid_posts_path(kid)
    end
  end

  def update
    @picture = Picture.find(params[:id])

    if @picture.update picture_params
      # ensures @picture.updated_at updates so that Picture.last_updated sorts as desired
      @picture.touch
    else
      flash[:error] = 'There was a problem setting the profile picture.  Please try again.'
    end

    redirect_to kid_posts_path @picture.kid_id
  end

  private

  def picture_params
    params.require(:picture).permit(:profile_picture)
  end

  def picture_destroying_transaction
    ActiveRecord::Base.transaction do
      begin
        pictures_posts = @picture.posts
        pictures_posts.update_all(picture_id: nil) if pictures_posts.present?
        @picture.destroy
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to destroy picture #{@picture}"
        false
      end
    end
  end

end
