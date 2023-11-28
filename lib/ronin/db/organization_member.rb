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
    # Represents a member of an {Organization}.
    #
    # @since 0.2.0
    #
    class OrganizationMember < ActiveRecord::Base

      include Model

      # NOTE: disable STI so we can use the type column as an enum.
      self.inheritance_column = nil

      # @!attribute [rw] id
      #   Primary key of the member.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] active
      #   Specifies whether the member is active or not.
      #
      #   @return [Boolean]
      attribute :active, :boolean, default: true

      # @!attribute [rw] type
      #   The type of organization membership.
      #
      #   @return [String, nil]
      enum :type, {
        advisor:      'advisor',
        volunteer:    'volunteer',
        employee:     'employee',
        contractor:   'contractor',
        intern:       'intern',
        board_member: 'board member'
      }

      # @!attribute [rw] role
      #   The member's role within the organization.
      #
      #   @return [String, nil]
      attribute :role, :string

      # @!attribute [rw] title
      #   The member's title.
      #
      #   @return [String, nil]
      attribute :title, :string

      # @!attribute [rw] rank
      #   The member's rank.
      #
      #   @return [String, nil]
      attribute :rank, :string

      # @!attribute [rw] person
      #   The person that belongs to the organization.
      #
      #   @return [Person]
      belongs_to :person

      # @!attribute [rw] department
      #   The department that belongs to within the organization.
      #
      #   @return [Department, nil]
      belongs_to :department, optional: true

      # @!attribute [rw] organization
      #   The organization that the member belongs to.
      #
      #   @return [Organization]
      belongs_to :organization

      # @!attribute [rw] email_address
      #   The member's organization email address.
      #
      #   @return [EmailAddress, nil]
      belongs_to :email_address, optional: true

      # @!attribute [rw] phone_number
      #   The member's organization phone number.
      #
      #   @return [EmailAddress, nil]
      belongs_to :phone_number, optional: true

      # @!attribute [r] created_at
      #   Tracks when the member was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [r] updated_at
      #   Tracks when the member was last updated.
      #
      #   @return [Time]
      attribute :updated_at, :datetime

      #
      # Queries members that are currently active.
      #
      # @return [Array<Member>]
      #
      def self.active
        where(active: true)
      end

      #
      # Queries former members.
      #
      # @return [Array<Member>]
      #
      def self.former
        where(active: false)
      end

    end
  end
end

require 'ronin/db/organization'
require 'ronin/db/person'
require 'ronin/db/email_address'
require 'ronin/db/phone_number'
