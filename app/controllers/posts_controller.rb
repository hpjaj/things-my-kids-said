class PostsController < ApplicationController
  def index
  end

  def new
    @post = current_user.posts.build
    @kids = current_user.kids
  end

  def create
    if post_creation_transaction
      redirect_to posts_path
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def post_creation_transaction
    ActiveRecord::Base.transaction do
      begin
        @post = current_user.posts.create!(post_params)
        if params[:post][:kids_ids].class == Array
          params[:post][:kids_ids].each do |kid_id|
            @post.kids << Kid.find(kid_id) if kid_id.present?
          end
        else
          @post.kids << Kid.find(params[:post][:kids_ids])
        end
      rescue Exception => e
        logger.error "User #{current_user.id} experience #{e.message} when trying to create a new post"
        raise ActiveRecord::Rollback
        false
      end
    end
  end
end
