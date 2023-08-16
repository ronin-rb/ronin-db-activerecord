# frozen_string_literal: true
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
# Creates the `ronin_street_addresses` table.
#
class CreateRoninStreetAddressesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_street_addresses, if_not_exists: true do |t|
      t.string :address, null: false, length: 46
      t.string :city, null: false, length: 58
      t.string :state, null: true, length: 13
      t.string :zipcode, null: true, length: 10
      t.string :country, null: false, length: 56
      t.datetime :created_at, null: false

      t.index [:address, :city, :state, :zipcode, :country], unique: true,
                                                             name:   :index_ronin_street_addresses_table_unique
      t.index :city
      t.index :state
      t.index :zipcode
      t.index :country
    end
  end

end
