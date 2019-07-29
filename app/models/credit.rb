class Credit < ApplicationRecord
   before_create :set_uuid

   include ::ImageConcern

   belongs_to :video, primary_key: :video_id
   has_one :person , primary_key: :people_id, foreign_key: :tmdb_people_id

   def set_uuid
     self.id = SecureRandom.uuid
   end
end
