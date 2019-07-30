require File.dirname(__FILE__) + '/../../config/environment.rb'
require 'tmdb_finder.rb'

namespace :tmdb do

  task :crawl_with_query, [:keyword] do |t, args|

#    Movie.delete_all
#    TvShow.delete_all
#    TvEpisode.delete_all
#    Video.delete_all
#    Credit.delete_all
#    Person.delete_all

    raise "something's wrong here" unless args.keyword.present?
    result =  TmdbFinder.get_search(args.keyword, 1)

    raise "Not Found results" unless result["results"].present?

    result["results"].each do |videos|
      ostruct = OpenStruct.new(videos)
      if Video.find_by(video_id: ostruct.id).blank?
        video = Video.new(video_id: ostruct.id, image_url: ostruct.poster_path, overview: ostruct.overview)
        case ostruct.media_type
        when "movie"
          v_media = Movie.new(release_date: ostruct.release_date, original_title: ostruct.original_title, title: ostruct.title)
          if v_media.save
            video.media_type = "Movie"
            video.media_id = v_media.id
            puts "Save to #{ostruct.title} / Movie"
            if video.save!
              Rake::Task["tmdb:get_movie_info"].invoke(ostruct.id)
              Rake::Task["tmdb:get_movie_info"].reenable
            else
              puts "Error on inner movie"
            end
          else
            puts "Error on movie"
          end
        when "tv"
          v_media = TvShow.new(first_air_date: ostruct.first_air_date, original_name: ostruct.original_name, name: ostruct.name)
          if v_media.save
            video.media_type = "TvShow"
            video.media_id = v_media.id
            puts "Save to #{ostruct.name} / TvShow"
            if video.save!
              Rake::Task["tmdb:get_tv_info"].invoke(ostruct.id)
              Rake::Task["tmdb:get_tv_info"].reenable
            else
              puts "Error on inner tv"
            end
          else
            puts "Error on tv"
          end
        else
          puts "Cant save with : #{ostruct}"
        end
      else
        puts "Skip #{ostruct.name}"
      end
    end
  end

  task :get_tv_info, [:tv_id] do |t, args|
    raise "something's wrong here" unless args.tv_id.present?

    res = OpenStruct.new(TmdbFinder.get_tv_info(args.tv_id))
    res.created_by.each do |creator|
      Rake::Task["tmdb:get_credit_info"].invoke(creator["credit_id"])
      Rake::Task["tmdb:get_credit_info"].reenable
    end
    Rake::Task["tmdb:get_tv_credit"].invoke(args.tv_id)
    Rake::Task["tmdb:get_tv_credit"].reenable

    res.seasons.each do |season|
      Rake::Task["tmdb:get_tv_season_info"].invoke(args.tv_id,season["season_number"])
      Rake::Task["tmdb:get_tv_season_info"].reenable
    end

  end

  task :get_tv_season_info, [:tv_id, :season_id] do |t, args|
    raise "something's wrong here" unless args.tv_id.present? && args.season_id.present?
    res = OpenStruct.new(TmdbFinder.get_tv_season_info(args.tv_id, args.season_id))
    res.episodes.each do |epi|
      if TvEpisode.find_by(episode_id: epi["id"]).blank?
        episode_data = OpenStruct.new(epi)
        tv_show = Video.find_by(video_id: episode_data.show_id, media_type: "TvShow")
        episode = TvEpisode.new(name: episode_data.name, tv_show_id: tv_show.media_id, episode_id: episode_data.id, air_date: episode_data.air_date, episode_number: episode_data.episode_number, season_number: episode_data.season_number, image_url: episode_data.still_path)
        raise 'Error on episode Save' unless episode.save!
      end
    end
  end

  task :get_movie_info, [:movie_id] do |t, args|
    raise "something's wrong here" unless args.movie_id.present?

    res = OpenStruct.new(TmdbFinder.get_movie_info(args.movie_id))
    Rake::Task["tmdb:get_movie_credit"].invoke(args.movie_id)
    Rake::Task["tmdb:get_movie_credit"].reenable

  end

  task :get_credit_info, [:credit_id] do |t, args|
    raise "something's wrong here" unless args.credit_id.present?

    if Credit.find_by(credit_id: args.credit_id).blank?
      res = OpenStruct.new(TmdbFinder.get_credit_info(args.credit_id))
      credit = Credit.new(character: res.person["name"], credit_id: args.credit_id, people_id: res.person["id"], video_id: res.media["id"], gender: nil, profile_url: res.profile_path, job: res.job)
      if credit.save!
        Rake::Task["tmdb:get_people_info"].invoke(res.person["id"])
        Rake::Task["tmdb:get_people_info"].reenable
      else
        puts "Error on credit info"
      end
    end

  end

  task :get_tv_credit, [:tv_id] do |t, args|
    raise "something's wrong here" unless args.tv_id.present?

    res = OpenStruct.new(TmdbFinder.get_tv_credit(args.tv_id))

    res.cast.each do |casts|
      cast_data = OpenStruct.new(casts)
      if Credit.find_by(credit_id: cast_data.credit_id).blank?
        credit_with_job = OpenStruct.new(TmdbFinder.get_credit_info(cast_data.credit_id))
        credit = Credit.new(character: cast_data.character, credit_id: cast_data.credit_id, people_id: cast_data.id, video_id: credit_with_job.media["id"], gender: cast_data.gender, profile_url: cast_data.profile_path, job: credit_with_job.job)
        if credit.save!
          Rake::Task["tmdb:get_people_info"].invoke(cast_data.id)
          Rake::Task["tmdb:get_people_info"].reenable
        else
          puts "Error on tv_credit"
        end
      else
        puts "Already have #{cast_data}"
      end
    end
  end

  task :get_movie_credit, [:movie_id] do |t, args|
    raise "something's wrong here" unless args.movie_id.present?

    res = OpenStruct.new(TmdbFinder.get_movie_credit(args.movie_id))
    res.cast.each do |casts|
      cast_data = OpenStruct.new(casts)
      if Credit.find_by(credit_id: cast_data.credit_id).blank?
        credit_with_job = OpenStruct.new(TmdbFinder.get_credit_info(cast_data.credit_id))
        credit = Credit.new(character: cast_data.character, credit_id: cast_data.credit_id, people_id: cast_data.id, video_id: credit_with_job.media["id"], gender: cast_data.gender, profile_url: cast_data.profile_path, job: credit_with_job.job)
        if credit.save!
          Rake::Task["tmdb:get_people_info"].invoke(cast_data.id)
          Rake::Task["tmdb:get_people_info"].reenable
        else
          puts "Error on movie_credit"
        end
      end
    end
  end

  task :get_people_info, [:people_id] do |t, args|
    raise "something's wrong here" unless args.people_id.present?

    res = OpenStruct.new(TmdbFinder.get_people_info(args.people_id))
    if Person.find_by(tmdb_people_id: res.id).blank?
      person = Person.new(tmdb_people_id: res.id, name: res.name, gender: res.gender, profile_url: res.profile_path)
      raise 'error on Person' unless person.save!
    else
      puts "Already have #{res}"
    end
  end
end
