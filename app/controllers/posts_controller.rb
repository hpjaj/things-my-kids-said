class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @kid = Kid.find(params[:kid_id])

    authorize! :read, @kid

    @posts = Post.user_can_see_for(@kid, current_user).order('date_said DESC').paginate(:page => params[:page], :per_page => 20)

    @pictures = Picture.for @kid
    @friends_and_family = @kid.followers.order(:last_name)
  end

  def new
    @post = current_user.posts.build
    @picture = Picture.new
  end

  def create
    authorize! :create, Post
    @picture = Picture.new
    @post    = current_user.posts.build(post_params)

    if post_creation_transaction
      redirect_to post_path(@post)
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])

    authorize! :read, @post

    @comments = @post.comments.order('created_at DESC')
  end

  def display_comments
    post = Post.find(params[:post_id])
    @comments = post.comments
    render nothing: true
  end

  def edit
    @post = Post.find(params[:id])
    @picture = @post.picture || Picture.new

    authorize! :update, @post
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    @picture = @post.picture || Picture.new

    if post_update_transaction
      redirect_to post_path(@post)
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    authorize! :destroy, @post

    if @post.destroy
      flash[:notice] = 'Your quote was successfully deleted.'
      redirect_to home_path
    else
      flash[:error] = 'There was a problem deleting your quote. Please try again.'
      render :show
    end
  end

  def select_picture
    picture_id = PostPicture.new(params, @post, current_user).determine_quotes_picture(params[:kid_id])
    @photo     = picture_id ? Picture.find(picture_id).photo : nil

    respond_to do |format|
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id, :kid_id, :kids_age, :years_old, :months_old, :date_said, :parents_eyes_only, pictures_attributes: [:picture])
  end

  def determine_date_said(params)
    # See PR for explanation of this first `if` check: https://github.com/hpjaj/things-my-kids-said/pull/8
    if params[:post][:kid_id].empty?
      nil
    elsif params[:post][:kids_age] == 'custom_age'
      years_old  = params[:post][:years_old].to_i.years
      months_old = params[:post][:months_old].to_i.months

      Kid.find(params[:post][:kid_id]).birthdate + years_old + months_old
    else
      params[:post][:kids_age].to_date
    end
  end

  def post_creation_transaction
    ActiveRecord::Base.transaction do
      begin
        @post.date_said = determine_date_said(params)
        @post.save!

        PostPicture.new(params, @post, current_user).set_picture_id

        @post.save!
      rescue Exception => e
        @post.kid_id = nil
        logger.error "User #{current_user.id} experienced #{e.message} when trying to create a new post"
        false
      end
    end
  end

  def post_update_transaction
    ActiveRecord::Base.transaction do
      begin
        @post.update!(post_params)

        PostPicture.new(params, @post, current_user).set_picture_id

        @post.save!
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to update post #{@post}"
        false
      end
    end
  end

end
