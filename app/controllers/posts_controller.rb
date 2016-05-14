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

  def edit
    @post = Post.find(params[:id])
    @kids = current_user.kids
  end

  def update
    @post = Post.find(params[:id])
    @kids = current_user.kids

    if @post.update(post_params)
      redirect_to posts_path
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.delete
      flash[:notice] = 'Your quote was successfully deleted.'
      redirect_to posts_path
    else
      flash[:error] = 'There was a problem deleting your quote. Please try again.'
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id, :kid_id, :kids_age)
  end
  end

end
