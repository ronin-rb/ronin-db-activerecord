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

require 'ronin/db/model'

require 'active_record'

module Ronin
  module DB
    #
    # Represents an email address associated with an {Organization}.
    #
    # @since 0.2.0
    #
    class OrganizationEmailAddress < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the member.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] organization
      #   The organization.
      #
      #   @return [Organization]
      belongs_to :organization

      # @!attribute [rw] email_address
      #   The email address associated with the organization.
      #
      #   @return [EmailAddress]
      belongs_to :email_address
      validates :email_address, uniqueness: {scope: :organization_id}

      # @!attribute [r] created_at
      #   Tracks when the organization email address was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require 'ronin/db/email_address'
require 'ronin/db/organization'
