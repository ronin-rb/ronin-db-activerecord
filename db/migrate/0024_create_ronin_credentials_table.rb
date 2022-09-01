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

class CreateRoninCredentialsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_credentials, if_not_exists: true do |t|
      t.references :user_name, null: true,
                               foreign_key: {
                                 to_table: :ronin_user_names
                               }
      t.references :password,  null: false,
                               foreign_key: {
                                 to_table: :ronin_passwords
                               }

      t.references :open_port, null: true,
                               foreign_key: {
                                 to_table: :ronin_open_ports
                               }
      t.references :email_address, null: true,
                                   foreign_key: {
                                     to_table: :ronin_email_addresses
                                   }
      t.references :url, null: true,
                         foreign_key: {
                           to_table: :ronin_urls
                         }

      t.index [:user_name_id, :password_id, :open_port_id, :email_address_id, :url_id], unique: true,
        name: :index_ronin_credentials_table_unique
    end
  end

end
