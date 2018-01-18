# require 'pg'
require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'carrel_db'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
