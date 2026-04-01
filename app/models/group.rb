class Group < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
end
