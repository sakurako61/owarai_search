class Performer < ApplicationRecord
  belongs_to :post
  belongs_to :group
  belongs_to :comedian
end
