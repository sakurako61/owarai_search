class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

  has_one_attached :user_image

  validates :user_image, content_type: ACCEPTED_CONTENT_TYPES,
                        size: { less_than_or_equal_to: 5.megabytes }

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:encrypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:encrypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:encrypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
end
