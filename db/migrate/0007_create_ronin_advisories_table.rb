#
# ronin-exploits - A Ruby library for ronin-rb that provides exploitation and
# payload crafting functionality.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-exploits.
#
# ronin-exploits is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-exploits is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ronin-exploits.  If not, see <https://www.gnu.org/licenses/>
#

#
# @api private
#
class CreateRoninAdvisoriesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_advisories, id: false, if_not_exists: true do |t|
      t.string :id, primary_key: true, null: false

      t.string :prefix, null: false
      t.integer :year, null: true
      t.string :identifier, null: false

      t.index :id, unique: true
      t.index :publisher
      t.index :year
    end
  end

end
