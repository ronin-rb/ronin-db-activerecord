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
# Creates the `ronin_phone_number` table.
#
class CreateRoninPhoneNumbersTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_phone_numbers, if_not_exists: true do |t|
      t.string :number, null: false, length: 17

      t.string :country_code, null: true,  length: 2
      t.string :area_code,    null: true,  length: 3
      t.string :prefix,       null: false, length: 3
      t.string :line_number,  null: false, length: 4

      t.datetime :created_at, null: false

      t.index :number, unique: true
      t.index :country_code
      t.index :area_code
      t.index :prefix
      t.index :line_number
    end
  end

end
