class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  scope :friend_requests, -> { where(notice_type: 'friendRequest') }
  scope :likes, -> { where(notice_type: 'like') }
  scope :comments, -> { where(notice_type: 'comment') }
end
