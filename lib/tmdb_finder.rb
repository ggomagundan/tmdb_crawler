require 'Tmdb'
require 'dotenv/load'

Tmdb.setup do | config |
  config.api_key = ENV['TMDB_API_KEY']
end

class TmdbFinder
  def self.get_search(keyword, page)
    JSON.parse(Tmdb.search(keyword, page))
  end

  def self.get_tv_info(id)
    JSON.parse(Tmdb.tv_info(id))
  end

  def self.get_tv_season_info(id, season_number)
    JSON.parse(Tmdb.tv_season_info(id, season_number))
  end

  def self.get_tv_credit(id)
    JSON.parse(Tmdb.tv_credit(id))
  end

  def self.get_movie_info(id)
    JSON.parse(Tmdb.movie_info(id))
  end

  def self.get_movie_credit(id)
    JSON.parse(Tmdb.movie_credit(id))
  end

  def self.get_people_info(id)
    JSON.parse(Tmdb.people_info(id))
  end

  def self.get_credit_info(id)
    JSON.parse(Tmdb.credit_info(id))
  end
end
