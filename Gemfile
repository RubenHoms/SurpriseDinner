source 'https://rubygems.org'

gem 'rails', '4.2.8'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'bourbon'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Move ffaker out of development test because it does not play nice with preloading the environment during deploy
gem 'ffaker'

# Authentication
gem 'devise'

# Templating
gem 'bootstrap-sass', '~> 3.3.6'
gem 'slim-rails'

# Form specific gems
gem 'simple_form'
gem 'country_select'
gem 'momentjs-rails', '~> 2.9',  :github => 'derekprior/momentjs-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'tinymce-rails'

# Payment gems
gem 'mollie-api-ruby'
gem 'sepa_king'

# SMS Gateway
gem 'cm-sms-rails'

# Use draper as decorator lib
gem 'draper', '~> 1.3'

# Use annotate to annotate the models with the database schema structure
gem 'annotate'

# Model validations
gem 'email_validator'
gem 'phony_rails'
gem 'validates_timeliness', '~> 4.0'
gem 'geocoder'
gem 'money-rails'

# App server
gem 'puma', '3.10.0'

# Assets
gem 'jquery-rails'
gem 'gmaps4rails'
gem 'underscore-rails'
gem 'image_optim_rails'
gem 'image_optim_pack'

# Environment variables
gem 'figaro'

# Wizard
gem 'wicked'

# File uploading
gem 'paperclip'
gem 'paperclip-optimizer', github: 'RubenHoms/paperclip-optimizer'
gem 'aws-sdk'

# Monitoring
gem 'sentry-raven'

# Jobs
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.0'
gem 'sidekiq-unique-jobs'

# Slack notifier
gem 'slack-notifier'

# Admin tools
gem 'activeadmin', github: 'activeadmin'
gem 'pundit'
gem 'cancan'
gem 'chartkick'
gem 'groupdate'

# Transactional emails
gem 'mandrill-api'

# XML Tools
gem 'nokogiri'

# Lock the app in staging
gem 'lockup'

# SEO tools
gem 'sitemap_generator'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

  # OSX guard notifications
  gem 'terminal-notifier-guard'

  # Test mails locally
  gem 'mailcatcher'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'capybara'

  # Factory Girl will be used for creating object factories
  gem 'factory_girl_rails', '~> 4.0'

  # Stub API requests
  gem 'webmock'

  # Pronto
  gem 'pronto'
  gem 'pronto-rubocop', require: false
end

group :production do
  gem 'remote_syslog_logger'
  gem 'lograge'
end
