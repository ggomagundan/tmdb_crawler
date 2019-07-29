module ImageConcern
  extend ActiveSupport::Concern

   BASE_URL = "https://image.tmdb.org/t/p/w500"

  def image_full_url
    if self.try(:image_url) || self.try(:profile_url)
      "#{BASE_URL}#{self.try(:image_url) || self.try(:profile_url)}"
    else
      return ActionController::Base.helpers.asset_path("no-image.png") unless ["Person", "Credit"].include? self.class.name
      return ActionController::Base.helpers.asset_path("person.png") if ["Person", "Credit"].include? self.class.name
    end
  end

end
