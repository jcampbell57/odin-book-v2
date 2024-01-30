source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bootsnap", require: false
gem 'bootstrap', '~> 5.3.2'
gem 'carrierwave', '~> 3.0'
gem 'cloudinary'
gem 'dartsass-sprockets'
gem "devise", "~> 4.9"
gem "dockerfile-rails", ">= 1.6", :group => :development
gem 'faker'
gem "importmap-rails"
gem "jbuilder"
gem 'jquery-rails'
gem "letter_opener", group: :development
gem "mini_magick"
gem 'omniauth-github', '~> 2.0.0'
gem 'omniauth-rails_csrf_protection'
gem 'pagy', '~> 6.2'
gem "pg", "~> 1.1"
gem 'puma', '~> 6.4', '>= 6.4.2'
gem "rails", "~> 7.1.2"
gem "redis", "~> 5.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
