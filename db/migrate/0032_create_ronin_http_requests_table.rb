#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-db-activerecord.
#
# ronin-db-activerecord is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-db-activerecord is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-db-activerecord.  If not, see <https://www.gnu.org/licenses/>.
#

#
# Creates the `ronin_http_requests` table.
#
class CreateRoninHttpRequestsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_http_requests, if_not_exists: true do |t|
      t.string :request_method, length: 9, null: false
      t.string :version, length: 3, null: false
      t.string :path, null: false
      t.text :body

      t.references :response, foreign_key: {
                                to_table: :ronin_http_responses
                              }

      t.datetime :created_at, null: false

      t.index :request_method
      t.index :path
    end
  end
end
