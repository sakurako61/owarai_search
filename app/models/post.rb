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

  validate :date_order

  private

  def date_order
    if open_date.present? && start_date.present?
      errors.add(:start_date, "は開場日時以降にしてください") if start_date < open_date
    end

    if start_date.present? && end_date.present?
      errors.add(:end_date, "は開始日時より後にしてください") if end_date <= start_date
    end

    if ticket_start_date.present? && ticket_end_date.present?
      errors.add(:ticket_end_date, "はチケット販売開始日時より後にしてください") if ticket_end_date <= ticket_start_date
    end
  end
  # validates :price
  validates :live_url, presence: true,
                       format: { with: /\Ahttps?:\/\/\S+\z/i, message: "はhttpまたはhttpsから始まるURLを入力してください" }

  # place_id 場所
  belongs_to :user
  belongs_to :place
end
