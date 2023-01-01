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

class CreateRoninAsnsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_asns, if_not_exists: true do |t|
      t.integer :version, null: false

      t.string :range_start, null: false
      t.string :range_end,   null: false

      t.binary :range_start_hton, null: false, length: 16
      t.binary :range_end_hton,   null: false, length: 16

      t.integer :number, null: false
      t.string :country_code, null: true
      t.string :name, null: true

      t.index :range_start_hton
      t.index :range_end_hton
      t.index [:range_start, :range_end], unique: true
    end
  end

end
