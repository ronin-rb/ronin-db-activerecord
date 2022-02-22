#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

class CreateRoninHostNameIpAddressesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_host_name_ip_addresses, if_not_exists: true do |t|
      t.references :host_name, null: false,
                               foreign_key: {
                                 to_table: :ronin_host_names
                               }
      t.references :ip_address, null: false,
                                foreign_key: {
                                  to_table: :ronin_ip_addresses
                                }
      t.datetime :created_at, null: false

      t.index [:host_name_id, :ip_address_id], unique: true,
                                               name: :index_ronin_host_name_ip_addresses_unique
      t.index :host_name_id
      t.index :ip_address_id
    end
  end

end
