class SearchController < ApplicationController
  before_action :authenticate_user!

  def main
    search_terms = params[:query]

    if search_terms
      @posts = Post.search_by_body(search_terms).all_for_user_for_search(current_user).paginate(:page => params[:page], :per_page => 20)
    else
      @posts = []
    end
  end
end
