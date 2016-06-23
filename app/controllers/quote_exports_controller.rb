class QuoteExportsController < ApplicationController
  def my_kids
    @posts = Post.parents_can_see(current_user).order(:kid_id).order('created_at DESC')

    send_data @posts.to_csv, filename: "things-my-kids-said-#{Date.today}.csv"
  end
end
