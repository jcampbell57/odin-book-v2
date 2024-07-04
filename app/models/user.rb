class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  mount_uploader :image, UserImageUploader
  validate :picture_size

  after_create :send_welcome_email

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification',
                                foreign_key: 'notice_id',
                                inverse_of: 'originator',
                                dependent: :destroy

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
  has_many :pending_requests_sent, -> { merge(Friendship.not_friends) },
           through: :sent_friend_requests, source: :sent_to
  has_many :pending_requests_received, -> { merge(Friendship.not_friends) },
           through: :recieved_friend_requests, source: :sent_by
  # END FRIENDSHIP ASSOCIATIONS

  def demo_user?
    email.in?(['humblebragger@humblebrag.com', 'fitnessgrampacer@test.com'])
  end

  # Returns a string containing this user's first name and last name
  def full_name
    "#{fname} #{lname}"
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.fname = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.github_data'] && session['devise.github_data']['extra']['raw_info']) && user.email.blank?
        user.email = data['email']
      end
    end
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end

  def send_welcome_email
    WelcomeMailer.with(user: self).welcome_email.deliver_later
  end
end
