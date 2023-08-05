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
# Creates the `ronin_certs` table.
#
class CreateRoninCertsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_certs, if_not_exists: true do |t|
      t.string :serial, length: 32, null: false
      t.integer :version, null: false
      t.datetime :not_before, null: false
      t.datetime :not_after, null: false

      # NOTE: self-signed certs dont' have #issuer set
      t.references :issuer, null: true,
                            foreign_key: {
                              to_table: :ronin_cert_issuers
                            }
      t.references :subject, null: false,
                             foreign_key: {
                               to_table: :ronin_cert_subjects
                             }

      t.string :public_key_algorithm, length: 3, null: false
      t.integer :public_key_size, null: true
      t.string :signing_algorithm, length: 12, null: false

      t.string :sha1_fingerprint, length: 40, null: false
      t.string :sha256_fingerprint, length: 64, null: false

      t.text :pem, null: false
      t.datetime :created_at, null: false

      t.index :serial
      t.index :sha1_fingerprint, unique: true
      t.index :sha256_fingerprint, unique: true
    end
  end

end
