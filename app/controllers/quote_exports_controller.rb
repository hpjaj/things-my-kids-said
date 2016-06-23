class QuoteExportsController < ApplicationController
  before_action :authenticate_user!

  def my_kids
    @posts = Post.parents_can_see(current_user).order(:kid_id).order('created_at DESC')

    authorize! :read, @posts.first

    send_data @posts.to_csv, filename: "things-my-kids-said-#{Date.today}.csv"
  end
end
