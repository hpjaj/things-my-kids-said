class PostsController < ApplicationController
  def index
  end

  def new
    @post = current_user.posts.build
    @kids = current_user.kids
  end

  def create
    @post = current_user.posts.build
    @kids = current_user.kids

    if post_creation_transaction
      redirect_to posts_path
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def post_creation_transaction
    ActiveRecord::Base.transaction do
      begin
        @post = current_user.posts.create!(post_params)
        if params[:post][:kid_ids].class == Array
          kids_ids = params[:post][:kid_ids].reject(&:empty?)

          kids_ids.each do |kid_id|
            @post.kids << Kid.find(kid_id)
          end
        else
          @post.kids << Kid.find(params[:post][:kid_ids])
        end
      rescue Exception => e
        logger.error "Error: User #{current_user.id} experienced '#{e.message}' when trying to create a new post"
        raise ActiveRecord::Rollback
        false
      end
    end
  end
end
