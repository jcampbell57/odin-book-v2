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
          @notification = @subject.user.notifications.build(notice_id: @current_user.id,
                                                            post_id: @subject.id,
                                                            notice_type:)
        elsif type == 'comment'
          @notification = @subject.user.notifications.build(notice_id: @current_user.id,
                                                            comment_id: @subject.id,
                                                            notice_type:)
        end
        @notification.save
      end
    end

    if type == 'post'
      render partial: 'posts/post', locals: { post: @subject }
    elsif type == 'comment'
      render partial: 'posts/post', locals: { post: Post.find(@subject.post_id) }
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
    else
      flash.now[:danger] = "#{type} unlike failed!"
      render turbo_stream: turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: })
    end
  end
end
