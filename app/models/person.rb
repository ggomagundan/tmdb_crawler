class Person < ApplicationRecord
   before_create :set_uuid

   include ::ImageConcern

   has_many :credits, primary_key: :tmdb_people_id, foreign_key: :people_id

   def set_uuid
     self.id = SecureRandom.uuid
   end
end
