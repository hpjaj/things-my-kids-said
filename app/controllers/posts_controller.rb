class PostsController < ApplicationController
  def index
  end

  def new
    @post = current_user.posts.build
  end

  def create
    if @post = current_user.posts.create(post_params)
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
end
