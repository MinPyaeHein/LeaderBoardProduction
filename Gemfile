source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# Use sqlite3 as the database for Active Record in development and test environments
group :development, :test do
  gem "sqlite3", "~> 1.4"
end

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# JSON Web Token support
gem 'jwt'

# PostgreSQL database adapter for Active Record
group :production do
  gem 'pg'
end

# Use Active Model Serializers
gem 'active_model_serializers'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# RSpec for testing
group :development, :test do
  gem 'rspec-rails', '~> 5.0'
  gem 'rswag', '~> 2.5'

  # PostgreSQL database adapter for Active Record
  gem 'pg'

  # Use Active Model Serializers
  gem 'active_model_serializers'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
