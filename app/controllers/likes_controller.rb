class LikesController < ApplicationController
  include ApplicationHelper

  def create
    type = type_subject?(params)[0]
    @subject = type_subject?(params)[1]
    notice_type = "like-#{type}"
    return unless @subject

    if already_liked?(type)
      unlike(type, @subject)
    else
      @like = @subject.likes.build(user_id: current_user.id)
      if @like.save
        if type == 'post'
          @notification = @subject.user.notifications.build(post_id: @subject.id, notice_type:)
        elsif type == 'comment'
          @notification = @subject.user.notifications.build(comment_id: @subject.id, notice_type:)
        end
        @notification.save
        flash[:success] = "#{type} liked!"
      else
        flash[:danger] = "#{type} like failed!"
      end
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def type_subject?(params)
    type = 'post' if params.key?('post_id')
    type = 'comment' if params.key?('comment_id')

    subject = Post.find(params[:post_id]) if type == 'post'
    subject = Comment.find(params[:comment_id]) if type == 'comment'

    [type, subject]
  end

  def already_liked?(type)
    result = false

    if type == 'post'
      result = Like.where(user_id: current_user.id,
                          post_id: params[:post_id]).exists?
    end

    if type == 'comment'
      result = Like.where(user_id: current_user.id,
                          comment_id: params[:comment_id]).exists?
    end

    result
  end

  def unlike(type, subject)
    if type == 'post'
      @like = Like.where(post_id: params[:post_id],
                         user_id: current_user.id).first
    elsif type == 'comment'
      @like = Like.where(comment_id: params[:comment_id],
                         user_id: current_user.id).first
    end
    return unless @like

    if type == 'post'
      @notification = Notification.where(post_id: params[:post_id],
                                         user_id: subject.user_id).first
    elsif type == 'comment'
      @notification = Notification.where(comment_id: params[:comment_id],
                                         user_id: subject.user_id).first
    end

    if @like.destroy
      @notification.destroy
      flash[:success] = "#{type} unliked!"
    else
      flash[:danger] = "#{type} unlike failed!"
    end
    redirect_back(fallback_location: root_path)
  end
end
