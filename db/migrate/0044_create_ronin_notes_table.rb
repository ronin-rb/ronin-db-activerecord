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
# Creates the `ronin_notes` table.
#
class CreateRoninNotesTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_notes, if_not_exists: true do |t|
      t.text :body, null: false
      t.timestamps

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

      t.references :port, null: true,
                          foreign_key: {
                            to_table: :ronin_ports
                          }

      t.references :service, null: true,
                             foreign_key: {
                               to_table: :ronin_services
                             }

      t.references :open_port, null: true,
                               foreign_key: {
                                 to_table: :ronin_open_ports
                               }

      t.references :cert, null: true,
                          foreign_key: {
                            to_table: :ronin_certs
                          }

      t.references :url, null: true,
                         foreign_key: {
                           to_table: :ronin_urls
                         }

      t.references :user_name, null: true,
                               foreign_key: {
                                 to_table: :ronin_user_names
                               }

      t.references :email_address, null: true,
                               foreign_key: {
                                 to_table: :ronin_email_addresses
                               }

      t.references :password, null: true,
                              foreign_key: {
                                to_table: :ronin_passwords
                              }

      t.references :credential, null: true,
                                foreign_key: {
                                  to_table: :ronin_credentials
                                }

      t.references :advisory, null: true,
                              foreign_key: {
                                to_table: :ronin_advisories
                              }

      t.references :street_address, null: true,
                                    foreign_key: {
                                      to_table: :ronin_street_addresses
                                    }

      t.references :phone_number, null: true,
                                  foreign_key: {
                                    to_table: :ronin_phone_numbers
                                  }

      t.index :mac_address_id
      t.index :ip_address_id
      t.index :host_name_id
      t.index :port_id
      t.index :service_id
      t.index :open_port_id
      t.index :cert_id
      t.index :url_id
      t.index :user_name_id
      t.index :email_address_id
      t.index :password_id
      t.index :credential_id
      t.index :advisory_id
      t.index :street_address_id
      t.index :phone_number_id
    end
  end

end
