class Video < ApplicationRecord
  before_create :set_uuid

  include ::ImageConcern

  belongs_to :media, polymorphic: true
  has_many :credits,  primary_key: :video_id

  default_scope { order(created_at: :desc) }

  def set_uuid
    self.id = SecureRandom.uuid
  end

  def original_video_title
    case media_type
    when "TvShow"
      media.original_name
    when "Movie"
      media.original_title
    else
      ""
    end
  end

  def video_title
    case media_type
    when "TvShow"
      media.name
    when "Movie"
      media.title
    else
      ""
    end
  end

  def actor_credits
    credits.where(job: "Actor")
  end

  def non_actor_credits
    credits.where.not(job: "Actor")
  end
end
