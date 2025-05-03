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
require_relative 'model/has_name'
require_relative 'model/importable'

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
      #   @return ["company", "government", "military", nil]
      #
      #   @since 0.2.0
      attribute :type, :string
      validates :type, allow_nil: true,
                       inclusion: {in: %w[company government military]}

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

      # @!attribute [rw] organization_host_names
      #   The association of organizations and host names.
      #
      #   @return [Array<OrganizationHostName>]
      #
      #   @since 0.2.0
      has_many :organization_host_names, dependent: :destroy

      # @!attribute [rw] host_names
      #   The host names that the organization owns.
      #
      #   @return [Array<HostName>]
      #
      #   @since 0.2.0
      has_many :host_names, through: :organization_host_names

      # @!attribute [rw] organization_ip_addresses
      #   The association of organizations and IP addresses.
      #
      #   @return [Array<OrganizationIPAddress>]
      #
      #   @since 0.2.0
      has_many :organization_ip_addresses, class_name: 'OrganizationIPAddress',
                                           dependent:  :destroy

      # @!attribute [rw] ip_addresses
      #   The IP addresses that the organization owns.
      #
      #   @return [Array<IPAddress>]
      #
      #   @since 0.2.0
      has_many :ip_addresses, through: :organization_ip_addresses

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

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

      #
      # Determines if the organization is a company.
      #
      # @return [Boolean]
      #
      # @since 0.2.0
      #
      def is_company?
        self.type == 'company'
      end

      #
      # Determines if the organization is a government organization.
      #
      # @return [Boolean]
      #
      # @since 0.2.0
      #
      def is_government?
        self.type == 'government'
      end

      #
      # Determines if the organization is a military organization.
      #
      # @return [Boolean]
      #
      # @since 0.2.0
      #
      def is_military?
        self.type == 'military'
      end

    end
  end
end

require_relative 'organization_street_address'
require_relative 'organization_phone_number'
require_relative 'organization_email_address'
require_relative 'organization_department'
require_relative 'organization_member'
require_relative 'organization_customer'
require_relative 'organization_host_name'
require_relative 'organization_ip_address'
require_relative 'note'
