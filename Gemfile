source "https://rubygems.org"

ruby "2.2.2"

gem "rails", "4.2.1"

gem "pg"

gem "date_validator"
gem "email_validator"
gem "figaro"
gem "harvested"
gem "honeybadger"
gem "icalendar"
gem "interactor"
gem "jbuilder"
gem "puma"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "accept_values_for"
  gem "codeclimate-test-reporter", require: false
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_girl_rails"
  gem "foreman"
  gem "pry-rails"
  gem "rspec-rails"
  gem "timecop"
  gem "webmock", require: false
end
