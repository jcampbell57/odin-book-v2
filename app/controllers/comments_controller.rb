class CommentsController < ApplicationController
  include ApplicationHelper

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:comment][:post_id])
    if @comment.save
      @notification = @post.user.notifications.build(post_id: @post.id,
                                                     notice_id: current_user.id,
                                                     notice_type: 'comment')
      @notification.save

      flash[:success] = 'Comment posted'
    else
      flash[:danger] = "Unable to comment: #{@post.errors.full_messages.join(', ')}"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user.id == @comment.user_id

    if @comment.destroy
      flash[:success] = 'Comment deleted'

      Notification.where(notice_id: current_user.id,
                         post_id: @comment.post_id,
                         notice_type: 'comment').first.destroy
    else
      flash[:danger] = "Unable to delete comment: #{@comment.errors.full_messages.join(', ')}"
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_id)
  end
end
