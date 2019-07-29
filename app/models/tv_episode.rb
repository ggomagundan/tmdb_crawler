class TvEpisode < ApplicationRecord
   before_create :set_uuid

   include ::ImageConcern

   belongs_to :tv_show

   def set_uuid
     self.id = SecureRandom.uuid
   end
end
