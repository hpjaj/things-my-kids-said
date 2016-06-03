class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

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
      redirect_to home_path
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
      redirect_to home_path
    else
      flash[:error] = 'There was a problem saving your quote.  Please try again.'
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.delete
      flash[:notice] = 'Your quote was successfully deleted.'
      redirect_to home_path
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
    if params[:post][:kid_id].empty?
      nil
      # This check was added to account for an edge case where date_said == custom_age,
      # and kid_id is blank.  Params with `custom_age` triggers the elsif block.
      # This blank kid_id was causing the elsif block to error out
      # on `Kid.find(params[:post][:kid_id]).birthdate`, as kid_id was blank.
      # Consequently, the @post.save line in :create was never being reached,
      # so model validation was never being triggered.
      # Thusly, this `if` check is now accounting for this edge case,
      # to ensure that the @post.save line is reached in the :create method,
      # thereby allowing validation in the model to be checked on kid_id presense.
    elsif params[:post][:kids_age] == 'custom_age'
      years_old  = params[:post][:years_old].to_i.years
      months_old = params[:post][:months_old].to_i.months

      Kid.find(params[:post][:kid_id]).birthdate + years_old + months_old
    else
      params[:post][:kids_age].to_date
    end
  end

end
