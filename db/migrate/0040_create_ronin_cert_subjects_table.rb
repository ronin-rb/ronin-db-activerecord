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
# Creates the `ronin_cert_subjects` table.
#
class CreateRoninCertSubjectsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_cert_subjects, if_not_exists: true do |t|
      t.references :common_name, null: false,
                                 foreign_key: {
                                   to_table: :ronin_cert_names
                                 }

      t.string :email_address, length: 320, null: true
      t.string :organization, null: false
      t.string :organizational_unit, null: true
      t.string :locality, null: true
      t.string :state, null: true
      t.string :country, null: false, length: 2

      t.datetime :created_at, null: false

      t.index [:common_name_id, :organization, :organizational_unit, :locality, :state, :country], unique: true,
                   name:   :index_ronin_cert_subjects_table_unique
      t.index :email_address
      t.index :organization
      t.index :organizational_unit
      t.index :locality
      t.index :country
    end
  end

end
