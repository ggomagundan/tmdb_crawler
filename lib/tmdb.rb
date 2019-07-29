require 'rest-client'
require 'openssl'

module Tmdb

  class << self
    attr_accessor :configuration
  end

  def self.setup
    @configuration ||= Configuration.new
    yield( configuration )
  end

  class Configuration
    attr_accessor :api_key

    def intialize
      @api_key    = ''
    end
  end

  def self.search(keyword, page)
    get '3/search/multi', query: keyword, page: page
  end

  def self.tv_info(tv_id)
    get "3/tv/#{tv_id}"
  end

  def self.tv_credit(tv_id)
    get "3/tv/#{tv_id}/credits"
  end

  def self.tv_season_info(tv_id, season_number)
    get "3/tv/#{tv_id}/season/#{season_number}"
  end

  def self.movie_info(movie_id)
    get "3/movie/#{movie_id}"
  end

  def self.movie_credit(movie_id)
    get "3/movie/#{movie_id}/credits"
  end

  def self.people_info(people_id)
    get "3/person/#{people_id}"
  end

  def self.credit_info(credit_id)
    get "3/credit/#{credit_id}"
  end

  protected

  def self.resource
    @@resouce ||= RestClient::Resource.new( 'https://api.themoviedb.org' )
  end

  def self.get( path, params = {} )
    puts "fetching from : #{path}"
    params[:api_key] = configuration.api_key
    resource[ path ].get params: params
  end

  def self.post( path, params = {} )
    # TODO 
    # implement code
  end
end
