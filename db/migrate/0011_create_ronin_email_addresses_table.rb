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
# Creates the `ronin_email_addresses` table.
#
class CreateRoninEmailAddressesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_email_addresses, if_not_exists: true do |t|
      t.string :address, length: 320, null: false
      t.references :user_name, null: false,
                               foreign_key: {
                                 to_table: :ronin_user_names
                               }
      t.references :host_name, null: false,
                               foreign_key: {
                                 to_table: :ronin_host_names
                               }
      t.datetime :created_at, null: false

      t.index :address, unique: true
      t.index :user_name_id
      t.index :host_name_id
      t.index [:user_name_id, :host_name_id], unique: true
    end
  end

end
