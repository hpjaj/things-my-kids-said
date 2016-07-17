class AdminController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    authorize! :manage, :all

    @users = User.order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    @kids = Kid.order(created_at: :desc)

    @feed = feed(30)
  end

  private

  def recent_users(count)
    User.last(count)
  end

  def recent_posts(count)
    Post.last(count)
  end

  def recent_kids(count)
    Kid.last(count)
  end

  def recent_comments(count)
    Comment.last(count)
  end

  def recent_f_and_f(count)
    FriendAndFamily.last(count)
  end

  def recent_filtered_kids(count)
    FilteredKid.last(count)
  end

  def feed(count)
    all_activity = recent_users(count) + recent_posts(count) + recent_kids(count) + recent_comments(count) + recent_f_and_f(count) + recent_filtered_kids(count)

    all_activity.sort_by { |quote| quote.created_at }.reverse.take(10)
  end

end
