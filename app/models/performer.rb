class Performer < ApplicationRecord
  belongs_to :post
  belongs_to :group, optional: true
  belongs_to :comedian
end
