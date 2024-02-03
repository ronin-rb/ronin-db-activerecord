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
    # Represents a street address.
    #
    # @since 0.2.0
    #
    class StreetAddress < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the street address.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] address
      #   The address number and street name.
      #
      #   @return [String]
      attribute :address, :string
      validates :address, presence: true,
                          length:   {maximum: 46},
                          uniqueness: {
                            scope: [
                              :city,
                              :state,
                              :zipcode,
                              :country
                            ]
                          }

      # @!attribute [rw] city
      #   The city name.
      #
      #   @return [String]
      attribute :city, :string
      validates :city, presence: true,
                       length:   {maximum: 58},
                       format:   {
                         with: /\A\p{Lu}\p{Ll}*(?:[\s'-]\p{Lu}\p{Ll}*)*\z/,
                         message: 'Must be a valid capitalized city name'
                       }

      # @!attribute [rw] state
      #   The state or province name.
      #
      #   @return [String, nil]
      attribute :state, :string
      validates :state, length: {maximum: 13},
                        format: {
                          with: /\A(?:[A-Z]{2}|\p{Lu}\p{Ll}*(?:\s\p{Lu}\p{Ll}*)*)\z/,
                          message: 'Must be a valid capitalized state or province name'
                        }

      # @!attribute [rw] zipcode
      #   The zipcode or postal code.
      #
      #   @return [String, nil]
      attribute :zipcode, :string
      validates :zipcode, length: {minimum: 4, maximum: 10},
                          format: {
                            with: /\A[A-Z0-9]+(?:[\s-][A-Z0-9]+)?\z/,
                            message: 'Must be a valid zipcode or postal code'
                          }

      # @!attribute [rw] country
      #   The country name.
      #
      #   @return [String]
      attribute :country, :string
      validates :country, presence: true,
                          length:   {maximum: 56},
                          format:   {
                            with: /\A(?:[A-Z]{2,3}|\p{Lu}\p{Ll}*(?:[\s-]\p{Lu}\p{Ll}*)*)\z/,
                            message: 'Must be a valid capitalized country name'
                          }

      # @!attribute [rw] created_at
      #   Tracks when the street address was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] personal_street_addresses
      #   The association of people that associate with the street address.
      #
      #   @return [Array<PersonalStreetAddress>]
      has_many :personal_street_addresses, dependent: :destroy

      # @!attribute [rw] people
      #   The people that are associated with the street addresses.
      #
      #   @return [Array<Organization>]
      has_many :people, through: :personal_street_addresses

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      has_many :notes

      # @!attribute [rw] organization_street_addresses
      #   The association of organizations that associate with the street
      #   address.
      #
      #   @return [Array<OrganizationStreetAddress>]
      has_many :organization_street_addresses, dependent: :destroy

      # @!attribute [rw] organization_departments
      #   The organization departments located at the street address.
      #
      #   @return [Array<OrganizationDepartment>]
      has_many :organization_departments, dependent: :nullify

      #
      # Queries all street addresses associated with the person's full name.
      #
      # @param [String] full_name
      #   The person's full name to search for.
      #
      # @return [Array<StreetAddress>]
      #   The street addresses associated with the person.
      #
      # @api public
      #
      def self.for_person(full_name)
        joins(:people).where(people: {full_name: full_name})
      end

      #
      # Queries all street addresses associated with an organization's name.
      #
      # @param [String] name
      #   The organization name to search for.
      #
      # @return [Array<StreetAddress>]
      #   The street addresses associated with the organization.
      #
      # @api public
      #
      def self.for_organization(name)
        joins(organization_street_addresses: :organization).where(
          organization_street_addresses: {
            ronin_organizations: {name: name}
          }
        )
      end

      #
      # Queries all street addresses with the matching address.
      #
      # @param [String] address
      #   The street address to search for.
      #
      # @return [Array<StreetAddress>]
      #   The matching street addresses.
      #
      # @api public
      #
      def self.with_address(address)
        where(address: address)
      end

      #
      # Queries all street addresses with the matching city.
      #
      # @param [String] city
      #   The city to search for.
      #
      # @return [Array<StreetAddress>]
      #   The matching street addresses.
      #
      # @api public
      #
      def self.with_city(city)
        where(city: city)
      end

      #
      # Queries all street addresses with the matching state.
      #
      # @param [String] state
      #   The state to search for.
      #
      # @return [Array<StreetAddress>]
      #   The matching street addresses.
      #
      # @api public
      #
      def self.with_state(state)
        where(state: state)
      end

      #
      # Alias for {with_state}.
      #
      # @see with_state
      #
      # @api public
      #
      def self.with_province(province)
        with_state(province)
      end

      #
      # Queries all street addresses with the matching country.
      #
      # @param [String] country
      #   The country to search for.
      #
      # @return [Array<StreetAddress>]
      #   The matching street addresses.
      #
      # @api public
      #
      def self.with_country(country)
        where(country: country)
      end

      #
      # Queries all street addresses with the matching zipcode.
      #
      # @param [String] zipcode
      #   The zipcode to search for.
      #
      # @return [Array<StreetAddress>]
      #   The matching street addresses.
      #
      # @api public
      #
      def self.with_zipcode(zipcode)
        where(zipcode: zipcode)
      end

      #
      # Alias for {#state}.
      #
      # @return [String, nil]
      #
      # @see state
      #
      # @api public
      #
      def province
        state
      end

      #
      # Alias for {#state=}.
      #
      # @param [String, nil] new_province
      #   The new province value.
      #
      # @return [String, nil]
      #
      # @see state=
      #
      # @api public
      #
      def province=(new_province)
        self.state = new_province
      end

      #
      # Alias for {#zipcode}.
      #
      # @return [String, nil]
      #
      # @see zipcode
      #
      # @api public
      #
      def postal_code
        zipcode
      end

      #
      # Alias for {#zipcode=}.
      #
      # @param [String, nil] new_postal_code
      #   The new postal code value.
      #
      # @return [String, nil]
      #
      # @see zipcode=
      #
      # @api public
      #
      def postal_code=(new_postal_code)
        self.zipcode = new_postal_code
      end

      #
      # Converts the street address to a String.
      #
      # @return [String]
      #
      def to_s
        string = "#{address}#{$/}#{city}"
        string << ", #{state}"  if state
        string << " #{zipcode}" if zipcode
        string << "#{$/}#{country}"
        return string
      end

    end
  end
end

require 'ronin/db/personal_street_address'
require 'ronin/db/person'
require 'ronin/db/organization_street_address'
require 'ronin/db/organization_department'
require 'ronin/db/note'
