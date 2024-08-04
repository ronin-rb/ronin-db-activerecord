# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'model'

require 'active_record'

module Ronin
  module DB
    #
    # Represents an association between an {Organization} and a {HostName}.
    #
    # @since 0.2.0
    #
    class OrganizationHostName < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the organization
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] organization
      #   The organization that owns the host name.
      #
      #   @return [Organization]
      belongs_to :organization

      # @!attribute [rw] host_name
      #   The host name that the organization owns.
      #
      #   @return [HostName]
      belongs_to :host_name

      # @!attribute [r] created_at
      #   Tracks when the organization claimed ownership of the host name.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require_relative 'organization'
require_relative 'host_name'
