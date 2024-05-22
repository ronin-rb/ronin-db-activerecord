# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'sqlite3', '~> 1.0', platforms: [:mri, :truffleruby]

platform :jruby do
  gem 'jruby-openssl',	'~> 0.7'
  gem 'activerecord-jdbcsqlite3-adapter', '~> 70.0'
  gem 'activerecord', '< 7.1.0'
end

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.2'

  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'

  gem 'kramdown',        '~> 2.0'
  gem 'redcarpet',       platform: :mri
  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'dead_end',        require: false
  gem 'sord',            require: false, platform: :mri
  gem 'stackprof',       require: false, platform: :mri
  gem 'rubocop',         require: false, platform: :mri
  gem 'rubocop-ronin',   require: false, platform: :mri
end
