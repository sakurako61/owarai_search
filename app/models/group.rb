class Group < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  has_many :group_comedians
  has_many :comedians, through: :group_comedians
end
