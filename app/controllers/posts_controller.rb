class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    kid    = Kid.find(params[:kid_id])
    @posts = kid.posts.order('date_said DESC')
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post           = current_user.posts.build(post_params)
    @post.date_said = determine_date_said(params)

    if @post.save
      redirect_to kid_posts_path(params[:post][:kid_id])
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

    if @post.update(post_params)
      redirect_to kid_posts_path(params[:post][:kid_id])
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.delete
      flash[:notice] = 'Your quote was successfully deleted.'
      redirect_to root_path
    else
      flash[:error] = 'There was a problem deleting your quote. Please try again.'
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id, :kid_id, :kids_age, :years_old, :months_old, :date_said)
  end

  def determine_date_said(params)
    if params[:post][:kids_age] == 'custom_age'
      years_old  = params[:post][:years_old].to_i.years
      months_old = params[:post][:months_old].to_i.months

      Kid.find(params[:post][:kid_id]).birthdate + years_old + months_old
    else
      params[:post][:kids_age].to_date
    end
  end

end
