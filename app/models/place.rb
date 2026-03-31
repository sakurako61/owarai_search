class Place < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :post_code, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :address, presence: true, length: { maximum: 200 }

  has_many :boards, dependent: :destroy
end
