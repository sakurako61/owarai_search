class Post < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

  has_one_attached :live_poster

  def live_poster=(attachable)
    if attachable.present? && attachable.respond_to?(:original_filename)
      attachable = process_and_transform_image(attachable, 800) || attachable
    end
    super
  end

  validates :live_poster, content_type: ACCEPTED_CONTENT_TYPES,
                        size: { less_than_or_equal_to: 5.megabytes }
  
  validates :live_name, presence: true, length: { maximum: 255 }
  validates :discription, length: { maximum: 65_535 }
  validates :open_date
  validates :start_date
  validates :end_date
  validates :ticket_start_date
  validates :ticket_end_date
  validates :price
  validates :live_url, presence: true

  # place_id 場所
  belongs_to :user
  belongs_to :place
end
