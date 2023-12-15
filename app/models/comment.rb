class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :post
  belongs_to :user

  has_many :likes, dependent: :destroy
end
