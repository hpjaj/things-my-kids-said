class PostsController < ApplicationController
  def index
    @posts = current_user.posts
  end

  def new
    @post = current_user.posts.build
    @kids = current_user.kids
  end

  def create
    @post = current_user.posts.build(post_params)
    @kids = current_user.kids

    if @post.save
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
    params.require(:post).permit(:body, :user_id, :kid_id)
  end

end
