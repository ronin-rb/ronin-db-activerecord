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
# Creates the `ronin_people` table.
#
class CreateRoninPeopleTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_people, if_not_exists: true do |t|
      t.string :full_name, null: false
      t.string :prefix, null: true, length: 6
      t.string :first_name, null: false
      t.string :middle_name, null: true
      t.string :middle_initial, null: true, length: 1
      t.string :last_name, null: true
      t.string :suffix, null: true, length: 3

      t.index :full_name, unique: true
      t.index :prefix
      t.index :first_name
      t.index :middle_name
      t.index :middle_initial
      t.index :last_name
      t.index :suffix
    end
  end

end
