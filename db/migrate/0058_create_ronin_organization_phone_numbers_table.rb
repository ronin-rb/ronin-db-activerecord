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
# Creates the `ronin_organization_phone_numbers` table.
#
class CreateRoninOrganizationPhoneNumbersTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_organization_phone_numbers, if_not_exists: true do |t|
      t.references :organization, null: false,
                                  foreign_key: {
                                    to_table: :ronin_organizations
                                  }

      t.references :phone_number, null: false,
                                  foreign_key: {
                                    to_table: :ronin_phone_numbers
                                  }

      t.datetime :created_at, null: false

      t.index [:organization_id, :phone_number_id], unique: true,
                                                    name:   :index_ronin_organization_phone_numbers_table_unique
    end
  end

end
