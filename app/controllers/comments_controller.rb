class CommentsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def create
    @comment         = Comment.new(comment_params)
    post             = Post.find_by(id: params[:post_id])
    @comment.user_id = current_user.id
    @comment.post_id = post.id

    unless @comment.save
      flash[:error] = 'There was a problem creating your comment.  Please try again.'
    end

    # render nothing: true
    redirect_to post_path(post.id)
  end

  def destroy
    @comment = Comment.find(params[:id])

    unless @comment.delete
      flash[:error] = 'There was a problem deleting your comment. Please try again.'
    end

    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :post_id)
  end
end
