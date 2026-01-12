# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require_relative 'model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a person.
    #
    # @since 0.2.0
    #
    class Person < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   The primary key of the person.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] full_name
      #   The person's full name.
      #
      #   @return [String]
      attribute :full_name, :string
      validates :full_name, presence:   true,
                            uniqueness: true,
                            format:     {
                              with: /\A(?:(?:Mr|Mrs|Ms|Miss|Dr|Sir|Madam|Master|Fr|Rev|Atty)\.?\s)?(?:\p{L}+(['-]\p{L}+)?)(?:(?:\s(?:(?:(?:\p{Lu})\.?)|(?:\p{Lu}\p{L}+(?:['-]\p{L}+)?)))?\s(?:\p{L}+(?:['-]\p{L}+)?)(?:,?\s(?:Jr|Sr|II|III|IV|V|Esq|CPA|Dc|Dds|Vm|Jd|Md|Phd)\.?)?)?\z/,
                              message: 'must be a valid personal name'
                            }

      # @!attribute [rw] prefix
      #   The person's prefix.
      #
      #   @return [String, nil]
      attribute :prefix, :string
      validates :prefix, inclusion: %w[
                           Mr Mrs Ms Miss Dr Sir Madam Master Fr Rev Atty
                         ],
                         allow_nil: true

      # @!attribute [rw] first_name
      #   The person's first name.
      #
      #   @return [String]
      attribute :first_name, :string
      validates :first_name, presence: true,
                             format:   {
                               with: /\A\p{L}+(?:['-]\p{L}+)?\z/,
                               message: 'must be a valid first name'
                             }

      # @!attribute [rw] middle_name
      #   The person's middle name.
      #
      #   @return [String, nil]
      attribute :middle_name, :string
      validates :middle_name, format:   {
                                with: /\A\p{L}+(?:['-]\p{L}+)?\z/,
                                message: 'must be a valid middle name'
                              },
                              allow_nil: true

      # @!attribute [rw] middle_initial
      #   The person's middle initial.
      #
      #   @return [String, nil]
      attribute :middle_initial, :string
      validates :middle_initial, presence: true,
                                 format:   {
                                   with: /\A\p{Lu}\z/,
                                   message: 'must be a valid middle initial'
                                 },
                                 allow_nil: true

      # @!attribute [rw] last_name
      #   The person's last name.
      #
      #   @return [String, nil]
      attribute :last_name, :string
      validates :last_name, format: {
                              with: /\A\p{L}+(?:['-]\p{L}+)?\z/,
                              message: 'must be a valid last name'
                            },
                            allow_nil: true

      # @!attribute [rw] suffix
      #   The person's suffix.
      #
      #   @return [String, nil]
      attribute :suffix, :string
      validates :suffix, inclusion: %w[
                           Jr Sr II III IV V Esq CPA Dc Dds Vm Jd Md Phd
                         ],
                         allow_nil: true

      # @!attribute [rw] created_at
      #   Tracks when the person was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] personal_street_addresses
      #   The association of street addresses associated with the person.
      #
      #   @return [Array<PersonalStreetAddress>]
      has_many :personal_street_addresses, dependent: :destroy

      # @!attribute [rw] street_addresses
      #   The street addresses associated with the person.
      #
      #   @return [Array<StreetAddress>]
      has_many :street_addresses, through: :personal_street_addresses

      # @!attribute [rw] personal_phone_numbers
      #   The perons's phone numbers.
      #
      #   @return [Array<PersonalPhoneNumber>]
      has_many :personal_phone_numbers, dependent: :destroy

      # @!attribute [rw] phone_numbers
      #   The phone numbers associated with the person.
      #
      #   @return [Array<PhoneNumber>]
      has_many :phone_numbers, through: :personal_phone_numbers

      # @!attribute [rw] personal_email_addresss
      #   The perons's email addresses.
      #
      #   @return [Array<PersonalEmailAddress>]
      has_many :personal_email_addresses, dependent: :destroy

      # @!attribute [rw] email_addresses
      #   The email addresses associated with the person.
      #
      #   @return [Array<EmailAddress>]
      has_many :email_addresses, through: :personal_email_addresses

      # @!attribute [rw] personal_connections
      #   The perons's connections with other people.
      #
      #   @return [Array<PersonalConnection>]
      has_many :personal_connections, dependent: :destroy

      # @!attribute [rw] connected_people
      #   The other people connected to the person.
      #
      #   @return [Array<Person>]
      has_many :connected_people, through: :personal_connections,
                                  source:  :other_person

      # @!attribute [rw] organization_customers
      #   The perons's customer relationships with other organizations.
      #
      #   @return [Array<OrganizationCustomer>]
      has_many :organization_customers, class_name:  'OrganizationCustomer',
                                        foreign_key: :customer_id,
                                        dependent:   :destroy

      # @!attribute [rw] vendors
      #   The vendor organizations of the person.
      #
      #   @return [Array<Organization>]
      has_many :vendors, through: :organization_customers

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      has_many :notes, dependent: :destroy

      #
      # Queries all people associated with the street address.
      #
      # @param [String] address
      #   The street address to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the street address.
      #
      # @api public
      #
      def self.for_address(address)
        joins(:street_addresses).where(street_addresses: {address: address})
      end

      #
      # Queries all people associated with the city.
      #
      # @param [String] city
      #   The city to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the city.
      #
      # @api public
      #
      def self.for_city(city)
        joins(:street_addresses).where(street_addresses: {city: city})
      end

      #
      # Queries all people associated with the state.
      #
      # @param [String] state
      #   The state to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the state.
      #
      # @api public
      #
      def self.for_state(state)
        joins(:street_addresses).where(street_addresses: {state: state})
      end

      #
      # Queries all people associated with the province.
      #
      # @param [String] province
      #   The province to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the province.
      #
      # @see for_state
      #
      # @api public
      #
      def self.for_province(province)
        for_state(province)
      end

      #
      # Queries all people associated with the zipcode.
      #
      # @param [String] zipcode
      #   The zipcode to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the zipcode.
      #
      # @api public
      #
      def self.for_zipcode(zipcode)
        joins(:street_addresses).where(street_addresses: {zipcode: zipcode})
      end

      #
      # Queries all people associated with the country.
      #
      # @param [String] country
      #   The country to search for.
      #
      # @return [Array<Person>]
      #   The people associated with the country.
      #
      # @api public
      #
      def self.for_country(country)
        joins(:street_addresses).where(street_addresses: {country: country})
      end

      #
      # Queries all people with the given prefix.
      #
      # @param [String] prefix
      #   The name prefix to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#prefix}.
      #
      # @api public
      #
      def self.with_prefix(prefix)
        where(prefix: prefix)
      end

      #
      # Queries all people with the matching first name.
      #
      # @param [String] first_name
      #   The first name to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#first_name}.
      #
      # @api public
      #
      def self.with_first_name(first_name)
        where(first_name: first_name)
      end

      #
      # Queries all people with the matching middle name.
      #
      # @param [String] middle_name
      #   The middle name to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#middle_name}.
      #
      # @api public
      #
      def self.with_middle_name(middle_name)
        where(middle_name: middle_name)
      end

      #
      # Queries all people with the matching middle initial.
      #
      # @param [String] initial
      #   The middle initial to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#middle_initial}.
      #
      # @api public
      #
      def self.with_middle_initial(initial)
        where(middle_initial: initial)
      end

      #
      # Queries all people with the matching last name.
      #
      # @param [String] last_name
      #   The last name to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#last_name}.
      #
      # @api public
      #
      def self.with_last_name(last_name)
        where(last_name: last_name)
      end

      #
      # Queries all people with the given suffix.
      #
      # @param [String] suffix
      #   The name suffix to search for.
      #
      # @return [Array<Person>]
      #   The people with the matching {#suffix}.
      #
      # @api public
      #
      def self.with_suffix(suffix)
        where(suffix: suffix)
      end

      #
      # Looks up a person by name.
      #
      # @param [String] name
      #   The person's full name to query.
      #
      # @return [Person, nil]
      #   The found person.
      #
      # @api public
      #
      def self.lookup(name)
        find_by(full_name: name)
      end

      #
      # Parses a person's full name into attributes.
      #
      # @param [String] name
      #   The person's full name to parse.
      #
      # @return [Hash{Symbol => String}]
      #   The parsed attributes.
      #
      # @api private
      #
      def self.parse(name)
        if (match = name.match(/\A(?:(?<prefix>Mr|Mrs|Ms|Miss|Dr|Sir|Madam|Master|Fr|Rev|Atty)\.?\s)?(?<first_name>\p{L}+(?:['-]\p{L}+)?)(?:(?:\s(?:(?:(?<middle_initial>\p{Lu})\.?)|(?<middle_name>(?<middle_initial>\p{Lu})\p{L}+(?:['-]\p{L}+)?)))?\s(?!Jr|Sr|II|III|IV|V|Esq|CPA|Dc|Dds|Vm|Jd|Md|Phd)(?<last_name>\p{L}+(?:['-]\p{L}+)?)(?:,?\s(?<suffix>Jr|Sr|II|III|IV|V|Esq|CPA|Dc|Dds|Vm|Jd|Md|Phd)\.?)?)?\z/))
          {
            full_name: name,

            prefix:         match[:prefix],
            first_name:     match[:first_name],
            middle_name:    match[:middle_name],
            middle_initial: match[:middle_initial],
            last_name:      match[:last_name],
            suffix:         match[:suffix]
          }
        else
          raise(ArgumentError,"invalid personal name: #{name.inspect}")
        end
      end

      #
      # Imports a person by name.
      #
      # @param [String] name
      #   The person's full name.
      #
      # @return [Person]
      #   The imported person.
      #
      # @api public
      #
      def self.import(name)
        create(parse(name))
      end

      #
      # Converts the person into a String.
      #
      # @return [String]
      #   The person's full name.
      #
      def to_s
        full_name
      end

    end
  end
end

require_relative 'personal_street_address'
require_relative 'personal_phone_number'
require_relative 'personal_connection'
require_relative 'organization_customer'
require_relative 'organization'
require_relative 'note'
