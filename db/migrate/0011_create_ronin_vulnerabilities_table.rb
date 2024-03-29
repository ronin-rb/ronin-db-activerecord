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
# Creates the `ronin_vulnerabilities` table.
#
class CreateRoninVulnerabilitiesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_vulnerabilities, if_not_exists: true do |t|
      t.references :mac_address, null: true,
                                foreign_key: {
                                  to_table: :ronin_mac_addresses
                                }
      t.references :ip_address, null: true,
                                foreign_key: {
                                  to_table: :ronin_ip_addresses
                                }
      t.references :host_name, null: true,
                               foreign_key: {
                                 to_table: :ronin_host_names
                               }
      t.references :open_port, null: true,
                              foreign_key: {
                                to_table: :ronin_open_ports
                              }
      t.references :url, null: true,
                         foreign_key: {
                           to_table: :ronin_urls
                         }
      t.references :advisory, null: false,
                              foreign_key: {
                                to_table: :ronin_advisories
                              }

      t.index :mac_address_id
      t.index :ip_address_id
      t.index :host_name_id
      t.index :open_port_id
      t.index :url_id
      t.index :advisory_id
    end
  end

end
