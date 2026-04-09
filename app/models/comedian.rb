class Comedian < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  belongs_to :agency, optional: true
  has_many :group_comedians
  has_many :groups, through: :group_comedians

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
