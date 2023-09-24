# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    # Represents a customer relationship of an {Organization}.
    #
    # @since 0.2.0
    #
    class OrganizationCustomer < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the customer relationship.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] vendor
      #   The vendor company.
      #
      #   @return [Organization]
      belongs_to :vendor, class_name: 'Organization'

      # @!attribute [rw] organization
      #   The customer organization.
      #
      #   @return [Organization, nil]
      belongs_to :customer_organization, class_name: 'Organization'
      validates :customer_organization, uniqueness: {scope: :vendor_id}

      # @!attribute [rw] person
      #   The customer organization.
      #
      #   @return [Person, nil]
      belongs_to :customer, class_name: 'Person'
      validates :customer, uniqueness: {scope: :vendor_id}

      # @!attribute [r] created_at
      #   Tracks when the customer relationship was first created
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require 'ronin/db/organization'
require 'ronin/db/person'
