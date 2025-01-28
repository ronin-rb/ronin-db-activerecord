# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    # Represents an association between an {Organization} and a {IPAddress}.
    #
    # @since 0.2.0
    #
    class OrganizationIPAddress < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the organization IP address.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] organization
      #   The organization that owns the IP address.
      #
      #   @return [Organization]
      belongs_to :organization

      # @!attribute [rw] ip_address
      #   The IP address that the organization owns.
      #
      #   @return [IPAddress]
      belongs_to :ip_address, class_name: 'IPAddress'

      # @!attribute [r] created_at
      #   Tracks when the organization claimed ownership of the IP address.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require_relative 'organization'
require_relative 'ip_address'
