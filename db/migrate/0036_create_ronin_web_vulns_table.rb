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
# Creates the `ronin_web_vulns` table.
#
class CreateRoninWebVulnsTable < ActiveRecord::Migration[7.0]

  def change
    create_table :ronin_web_vulns, if_not_exists: true do |t|
      t.string :type, null: false
      t.references :url, null: false,
      foreign_key: {
        to_table: :ronin_urls
      }

      t.string :query_param, length: 225, null: true
      t.string :header_name, length: 225, null: true
      t.string :cookie_param, length: 225, null: true
      t.string :form_param, length: 225, null: true

      t.string  :request_method, null: false
      t.string  :lfi_os, null: true
      t.integer :lfi_depth, null: true
      t.string  :lfi_filter_bypass, null: true
      t.string  :rfi_script_lang, null: true
      t.string  :rfi_filter_bypass, null: true
      t.string  :ssti_escape, null: true

      t.boolean :sqli_escape_quote, null: true
      t.boolean :sqli_escape_parens, null: true
      t.boolean :sqli_terminate, null: true

      t.index :type, unique: true
    end
  end

end
