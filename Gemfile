# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2', '>= 8.0.2.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cache'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Blueprinter for JSON serialization
gem 'blueprinter'

# Use dry-validation for validations [https://dry-rb.org/gems/dry-validation/]
gem 'dry-validation', '~> 1.8'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Use Rubocop for code linting
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false

  # Use RSpec for tests
  gem 'rspec-rails', '~> 6.0.0'

  # Use FactoryBot for test fixtures
  gem 'factory_bot_rails'

  # Use Faker for generating fake data
  gem 'faker'

  # Use Database Cleaner to ensure a clean state for tests
  gem 'database_cleaner-active_record'
end
