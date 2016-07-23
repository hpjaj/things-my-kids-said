class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @kid = Kid.find(params[:kid_id])

    authorize! :read, @kid

    @posts = Post.user_can_see_for(@kid, current_user).order('date_said DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    authorize! :create, Post

    @post           = current_user.posts.build(post_params)
    @post.date_said = determine_date_said(params)
    quotes_photo    = determine_quotes_picture(params[:post][:kid_id])

    if !params[:post][:photo].present? && quotes_photo
      set_photo_params(quotes_photo, @post)
    end

    if @post.save
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
    @comments = post.comments  # byebug
    Rails.logger.info "************ blah"
    # logger.info "************ blah"
    render nothing: true
    # render partial: 'display_comments', locals: @comments
  end

  def edit
    @post = Post.find(params[:id])

    authorize! :update, @post
  end

  def update
    @post = Post.find(params[:id])

    authorize! :update, @post

    quotes_photo = determine_quotes_picture(params[:post][:kid_id])

    if !params[:post][:photo].present? && quotes_photo
      set_photo_params(quotes_photo, @post)
    end

    if @post.update(post_params)
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
    @photo = determine_quotes_picture(params[:kid_id])

    respond_to do |format|
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id, :kid_id, :kids_age, :years_old, :months_old, :date_said, :parents_eyes_only, :photo)
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

  def set_photo_params(photo_ojbect, post)
    post.photo_file_name    = photo_ojbect.instance.photo_file_name
    post.photo_content_type = photo_ojbect.instance.photo_content_type
    post.photo_file_size    = photo_ojbect.instance.photo_file_size
    post.photo_updated_at   = photo_ojbect.instance.photo_updated_at
  end

  def determine_quotes_picture(kid_id)
    kid = Kid.find_by(id: kid_id)

    return unless kid

    last_post_with_photo = kid.posts.most_recent_with_photo

    return last_post_with_photo.try(:photo) || kid.photo || nil
  end

end
