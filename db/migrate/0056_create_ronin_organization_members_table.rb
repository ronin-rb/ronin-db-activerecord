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
# Creates the `ronin_organization_members` table.
#
class CreateRoninOrganizationMembersTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_organization_members, if_not_exists: true do |t|
      t.boolean :active, default: true
      t.string :type, null: true, length: 12
      t.string :role
      t.string :title
      t.string :rank

      t.references :person, null: false,
                            foreign_key: {
                              to_table: :ronin_people
                            }
      t.references :department, null: true,
                                foreign_key: {
                                  to_table: :ronin_organization_departments
                                }
      t.references :organization, null: false,
                                  foreign_key: {
                                    to_table: :ronin_organizations
                                  }
      t.references :email_address, null: true,
                                   foreign_key: {
                                     to_table: :ronin_email_addresses
                                   }
      t.references :phone_number, null: true,
                                  foreign_key: {
                                    to_table: :ronin_phone_numbers
                                  }
      t.timestamps

      t.index :type
    end
  end

end
