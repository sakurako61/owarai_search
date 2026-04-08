class Performer < ApplicationRecord
  belongs_to :post
  belongs_to :group, optional: true
  belongs_to :comedian

  def self.ransackable_attributes(auth_object = nil)
    ["comedian_id", "created_at", "group_id", "id", "post_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comedian"]
  end
end
