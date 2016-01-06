source "https://rubygems.org"

# Ruby
ruby "2.3.0"

# Rails
gem "rails", "4.2.5"

# Database
gem "pg"

# Server
gem "puma"

# Assets
gem "bootstrap-sass"
gem "bootstrap-chosen-rails"
gem "chosen-rails", ">= 1.4.3" # FIXME Avoids compass-rails incompatibility
gem "coffee-rails"
gem "font-awesome-rails"
gem "jquery-rails"
gem "sass-rails"
gem "uglifier"

# Runtime
gem "date_validator"
gem "email_validator"
gem "figaro"
gem "harvested"
gem "honeybadger"
gem "icalendar"
gem "interactor"
gem "jbuilder"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "accept_values_for"
  gem "capybara"
  gem "codeclimate-test-reporter", require: false
  gem "database_cleaner"
  gem "domino"
  gem "email_spec"
  gem "factory_girl_rails"
  gem "foreman"
  gem "pry-rails"
  gem "rspec-rails"
  gem "timecop"
  gem "webmock", require: false
end
