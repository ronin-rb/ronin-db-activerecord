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
# Adds the `created_at` column to the `ronin_services` table.
#
class AddCreatedAtColumnToRoninServicesTable < ActiveRecord::Migration[7.0]

  def up
    add_column :ronin_services, :created_at, :datetime

    execute 'UPDATE ronin_services SET created_at = (SELECT created_at FROM ronin_open_ports WHERE service_id = ronin_services.id)'

    change_column_null :ronin_services, :created_at, false
  end

  def down
    remove_column :ronin_services, :created_at
  end

end
