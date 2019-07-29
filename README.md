# TMDB Crawler

## Setup

### DB
```
# config/database.yml L:17
 development:
    <<: *default
    database: tmdb_development
    host: [Change Or 'localhost']
    port: 3306
```

# Excute DB Command
```
- rails db:create
- rails db:migrate
```

### Environment Value
```
# Copy and Open '.env' file

$ mv .env.example .env
$ vi .env

# Set TMDB API key
TMDB_API_KEY="[TMDB_API_KEY]"
```

###   Crawling TMDB
 ```
# On Terminal excute command and wait until finish

$ rake tmdb:crawl_with_query['KEYWORD']
```

### Turn on Rails Project
```
$ rails s
```

##  ETC

### installed Gem
```
## Gemfile L:66

 # For Crawl
gem 'rest-client'
gem 'dotenv-rails'

# For ActiveRecord IRB
gem 'hirb'

# For pagination
gem 'kaminari'

# For debug
 gem 'pry'
 ```
