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

require 'ronin/db/model'
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents an Company.
    #
    class Organization < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      # @!attribute [rw] id
      #   Primary key of the organization
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [r] created_at
      #   Tracks when the organization was first created
      #
      #   @return [Time]
      attribute :created_at, :time

    end
  end
end
