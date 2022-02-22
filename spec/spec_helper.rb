require 'rspec'

require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

require 'ronin/db/migrations'
Ronin::DB::Migrations.migrate

require 'simplecov'
SimpleCov.start
