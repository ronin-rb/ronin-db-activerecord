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
require 'ronin/db/model/has_name'
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents an Company.
    #
    class Organization < ActiveRecord::Base

      include Model
      include Model::HasName
      include Model::Importable

      # @!attribute [rw] id
      #   Primary key of the organization
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The type for the organization.
      #
      #   @return [String, nil]
      #
      #   @since 0.2.0
      enum :type, {
        company:    'company',
        government: 'government',
        military:   'military'
      }, prefix: 'is_'

      # @!attribute [r] created_at
      #   Tracks when the organization was first created
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] parent
      #   The optional parent organization.
      #
      #   @return [Organization, nil]
      #
      #   @since 0.2.0
      belongs_to :parent, optional:   true,
                          class_name: 'Organization'

      # NOTE: ensure the name is unique with respect to the parent organization
      validates :name, uniqueness: {scope: [:parent_id]}

      # @!attribute [rw] organization_street_addresses
      #   The association of street addresses associated with the organization.
      #
      #   @return [Array<OrganizationStreetAddress>]
      #
      #   @since 0.2.0
      has_many :organization_street_addresses, dependent: :destroy

      # @!attribute [rw] street_addresses
      #   The street addresses that are associated with the organization.
      #
      #   @return [Array<StreetAddress>]
      #
      #   @since 0.2.0
      has_many :street_addresses, through: :organization_street_addresses

      # @!attribute [rw] organization_phone_numbers
      #   The association of phone numbers associated with the organization.
      #
      #   @return [Array<OrganizationPhoneNumber>]
      #
      #   @since 0.2.0
      has_many :organization_phone_numbers, dependent: :destroy

      # @!attribute [rw] phone_numbers
      #   The phone numbers that are associated with the organization.
      #
      #   @return [Array<PhoneNumber>]
      #
      #   @since 0.2.0
      has_many :phone_numbers, through: :organization_phone_numbers

      # @!attribute [rw] organization_email_addresses
      #   The association of email addresses associated directly with the
      #   organization.
      #
      #   @return [Array<OrganizationEmailAddress>]
      #
      #   @since 0.2.0
      has_many :organization_email_addresses, dependent: :destroy

      # @!attribute [rw] organization_email_addresses
      #   The email addresses directly associated directly with the
      #   organization.
      #
      #   @return [Array<EmailAddress>]
      #
      #   @since 0.2.0
      has_many :email_addresses, through: :organization_email_addresses

      # @!attribute [rw] departments
      #   The associated departments of the organization.
      #
      #   @return [Array<OrganizationDepartment>]
      #
      #   @since 0.2.0
      has_many :departments, class_name: 'OrganizationDepartment',
                             dependent:  :destroy

      # @!attribute [rw] members
      #   The members that belong to the organization.
      #
      #   @return [Array<OrganizationMember>]
      #
      #   @since 0.2.0
      has_many :members, class_name: 'OrganizationMember'

      # @!attribute [rw] member_email_addresses
      #   The email addresses used by members of the organization.
      #
      #   @return [Array<EmailAddress>]
      #
      #   @since 0.2.0
      has_many :member_email_addresses, through: :members,
                                        source:  :email_address

      # @!attribute [rw] organization_customers
      #   The organization's customer relationships.
      #
      #   @return [Array<OrganizationCustomer>]
      #
      #   @since 0.2.0
      has_many :organization_customers, class_name:  'OrganizationCustomer',
                                        foreign_key: :vendor_id,
                                        dependent:   :destroy

      # @!attribute [rw] customers
      #   The individual customers (B2C) of the organization/
      #
      #   @return [Array<Person>]
      #
      #   @since 0.2.0
      has_many :customers, through: :organization_customers

      # @!attribute [rw] customer_organizations
      #   The other customer organizations (B2B) of the organization.
      #
      #   @return [Array<Organization>]
      #
      #   @since 0.2.0
      has_many :customer_organizations, through: :organization_customers

      # @!attribute [rw] vendor_relationships
      #   The organization's vendor relationships with other organizations.
      #
      #   @return [Array<OrganizationCustomer>]
      #
      #   @since 0.2.0
      has_many :organization_vendors, class_name:  'OrganizationCustomer',
                                      foreign_key: :customer_organization_id,
                                      dependent:   :destroy

      # @!attribute [rw] vendors
      #   The vendor companies that the organization is a customer of.
      #
      #   @return [Array<Organization>]
      #
      #   @since 0.2.0
      has_many :vendors, through: :organization_vendors

      #
      # Looks up the organization.
      #
      # @param [String] name
      #   The organization name to query.
      #
      # @return [Organization, nil]
      #   The found organization.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Imports an organization.
      #
      # @param [String] name
      #   The organization name to import.
      #
      # @return [Organization]
      #   The imported organization.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.import(name)
        create(name: name)
      end

    end
  end
end

require 'ronin/db/organization_street_address'
require 'ronin/db/organization_phone_number'
require 'ronin/db/organization_email_address'
require 'ronin/db/organization_department'
require 'ronin/db/organization_member'
require 'ronin/db/organization_customer'
