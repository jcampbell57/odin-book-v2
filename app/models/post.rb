class Post < ApplicationRecord
  validates :content, presence: true

  belongs_to :user

  mount_uploader :image, PostImageUploader

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # to produce activerecords for pagination with pagy gem:
  scope :friends_and_own_posts, lambda { |user|
    friend_ids = user.friends.pluck(:id) << user.id
    where(user_id: friend_ids).order(created_at: :desc)
  }
end
