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
    # Represents a {Organization}'s {PhoneNumber phone number}.
    #
    # @since 0.2.0
    #
    class OrganizationPhoneNumber < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the organization phone number.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] organization
      #   The organization.
      #
      #   @return [Organization]
      belongs_to :organization

      # @!attribute [rw] phone_number
      #   The phone number.
      #
      #   @return [PhoneNumber]
      belongs_to :phone_number
      validates :phone_number, uniqueness: {scope: :organization_id}

      # @!attribute [rw] created_at
      #   Tracks when the organization phone number was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require_relative 'organization'
require_relative 'phone_number'
