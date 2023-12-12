class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :picture_size

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # BEGIN FRIENDSHIP ASSOCIATIONS
  has_many :sent_friend_requests, class_name: 'Friendship',
                                  foreign_key: 'sent_by_id',
                                  inverse_of: 'sent_by',
                                  dependent: :destroy
  has_many :recieved_friend_requests, class_name: 'Friendship',
                                      foreign_key: 'sent_to_id',
                                      inverse_of: 'sent_to',
                                      dependent: :destroy
  has_many :friends, -> { merge(Friendship.friends) },
           through: :sent_friend_requests, source: :sent_to
  # Not sure if this one is functional:
  # (not needed because all friendships have two records,
  # so previous assosiaction will catch all)
  # has_many :friends, -> { merge(Friendship.friends) },
  #          through: :recieved_friend_requests, source: :sent_by
  has_many :pending_requests_sent, -> { merge(Friendship.not_friends) },
           through: :sent_friend_requests, source: :sent_to
  has_many :pending_requests_received, -> { merge(Friendship.not_friends) },
           through: :recieved_friend_requests, source: :sent_by
  # END FRIENDSHIP ASSOCIATIONS

  private

  # Validates the size of an uploaded picture.
  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
