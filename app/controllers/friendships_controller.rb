class FriendshipsController < ApplicationController
  include ApplicationHelper

  def create
    # Disallow the ability to send yourself a friend request
    return if current_user.id == params[:user_id]

    # Disallow the ability to send friend request more than once to same person
    return if friend_request_sent?(User.find(params[:user_id]))

    # Disallow the ability to send friend request to someone who already sent you one
    return if friend_request_received?(User.find(params[:user_id]))

    @user = User.find(params[:user_id])
    @friendship = current_user.sent_friend_requests.build(sent_to_id: params[:user_id])
    if @friendship.save
      @notification = @user.notifications.build(notice_id: @current_user.id, notice_type: 'friendRequest')
      @notification.save

      flash[:success] = 'Friend Request Sent!'
    else
      flash[:danger] = 'Friend Request Failed!'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = User.find(params[:user_id])
    @friendship = current_user.sent_friend_requests.find_by(sent_to_id: params[:user_id])

    if @friendship.destroy
      flash[:success] = 'Friend Request Canceled!'
      @notification = Notification.find_by(user_id: @user.id, notice_id: @current_user.id, notice_type: 'friendRequest')
      @notification.destroy
    else
      flash[:danger] = 'Failed to Cancel Friend Request!'
    end

    redirect_back(fallback_location: root_path)
  end

  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.status = true
    if @friendship.save
      flash[:success] = 'Friend Request Accepted!'
      @friendship2 = current_user.sent_friend_requests.build(sent_to_id: params[:user_id], status: true)
      @friendship2.save
    else
      flash[:danger] = 'Friend Request could not be accepted!'
    end

    redirect_back(fallback_location: root_path)
  end

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.destroy
    flash[:success] = 'Friend Request Declined!'
    redirect_back(fallback_location: root_path)
  end

  def remove_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: true)
    return unless @friendship # return if no record is found

    if @friendship.destroy
      flash[:success] = 'Friend removed!'
      reciprocal_friendship = Friendship.find_by(sent_by_id: current_user.id, sent_to_id: params[:user_id],
                                                 status: true)
      reciprocal_friendship.destroy
    else
      flash[:danger] = 'Friend removal failed!'
    end

    redirect_back(fallback_location: root_path)
  end
end
