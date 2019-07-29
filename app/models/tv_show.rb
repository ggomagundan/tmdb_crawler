class TvShow < ApplicationRecord
   before_create :set_uuid

   has_one :video, as: :media
   has_many :credits
   has_many :tv_episodes

   def set_uuid
     self.id = SecureRandom.uuid
   end
end
