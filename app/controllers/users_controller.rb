class UsersController < ApplicationController
  include ApplicationHelper

  def index
    @users = User.all
    @friends = current_user.friends
    @pending_requests = current_user.pending_requests_sent
    @friend_requests = current_user.pending_requests_received
    @other_users = User.all.reject { |user| user == current_user || possible_friend?(user) }
  end

  def show
    @user = User.find(params[:id])
  end

  def update_img
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_back(fallback_location: users_path(current_user))
      return
    end
    image = params[:user][:image] unless params[:user].nil?
    if image
      @user.image = image
      if @user.save
        flash[:success] = 'Image uploaded'
      else
        flash[:danger] = "Image upload failed: #{@user.errors.full_messages.join(', ')}"
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def notifications
    if current_user == User.find(params[:id])
      @new = current_user.notifications.where(viewed?: false).to_a
      @old = current_user.notifications.where(viewed?: true).to_a
      @new.each { |notification| notification.update(viewed?: true) }
    else
      redirect_to notifications_user_path(`current_user`)
    end
  end
end
