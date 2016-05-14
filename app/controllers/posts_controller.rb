class PostsController < ApplicationController

  def index
    @posts = current_user.posts
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post          = current_user.posts.build(post_params)
    @post.kids_age = set_age(params)

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
  end

  def update
    @post = Post.find(params[:id])
    age   = set_age(params)

    if @post.update(post_params.merge(kids_age: age))
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
    params.require(:post).permit(:body, :user_id, :kid_id, :kids_age, :years_old, :months_old)
  end

  def set_age(params)
    if params[:post][:kids_age] == 'custom_age'
      "#{params[:post][:years_old]} years #{params[:post][:months_old]} months old"
    else
      Age.new(Kid.find(params[:post][:kid_id]).birthdate, params[:post][:kids_age]).calculate
    end
  end

end
