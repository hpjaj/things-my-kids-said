class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment         = Comment.new(comment_params)
    post             = Post.find_by(id: params[:post_id])
    @comment.user_id = current_user.id
    @comment.post_id = post.id

    unless @comment.save
      flash[:error] = 'There was a problem creating your comment.  Please try again.'
    end

    render nothing: true
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :post_id)
  end
end
