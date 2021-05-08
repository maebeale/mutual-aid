source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.0'

# This should after rails but before any gems that might require it
gem 'dotenv-rails', require: 'dotenv/rails-now'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_interaction'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'blueprinter'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise'
gem 'faker' # need this in prod for demo seeds to work
gem 'jbuilder', '~> 2.7'
gem 'mobility', '~> 0.8.9'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rack-timeout'
gem 'sendgrid-ruby'
gem 'simple_form'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'binding_of_caller'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'pundit-matchers'
  gem 'rspec_junit_formatter' # an XML formatter is required for fancier CircleCI results
  gem 'selenium-webdriver'
end

group :development do
  gem 'annotate'
  gem 'listen', '~> 3.0'
  gem 'rerun'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec', require: false
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'standard', require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end
