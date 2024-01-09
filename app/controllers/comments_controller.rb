class CommentsController < ApplicationController
  include ApplicationHelper

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:comment][:post_id])
    return unless @comment.save

    @notification = @post.user.notifications.build(post_id: @post.id,
                                                   notice_id: current_user.id,
                                                   notice_type: 'comment')
    @notification.save
    render partial: 'posts/post', locals: { post: @post }
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user.id == @comment.user_id

    if @comment.destroy
      Notification.where(notice_id: current_user.id,
                         post_id: @comment.post_id,
                         notice_type: 'comment').first.destroy

      render partial: 'posts/post', locals: { post: Post.find(@comment.post_id) }
    else
      flash.now[:danger] = "Unable to delete comment: #{@comment.errors.full_messages.join(', ')}"
      render turbo_stream: turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: })
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_id)
  end
end
