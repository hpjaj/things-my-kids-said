class WelcomeController < ApplicationController

  def index
  end

  def home
    if current_user
      @posts = Post.all_associated_kids_posts(current_user).paginate(:page => params[:page], :per_page => 30)
    else
      flash[:notice] = 'Please sign in to access this page'
      redirect_to root_path
    end
  end

  def help
  end

end
