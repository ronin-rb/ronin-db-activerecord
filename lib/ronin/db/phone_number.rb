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
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a phone number.
    #
    # @since 0.2.0
    #
    class PhoneNumber < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   The primary key of the phone number.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] number
      #   The phone number.
      #
      #   @return [String]
      attribute :number, :string
      validates :number, presence:   true,
                         format:     {
                           with: /\A(?:\+?\d{1,2}[\s.-])?(?:(?:\(\d{3}\)|\d{3})[\s.-])?\d{3}[\s.-]\d{4}\z/,
                           message: 'must be a valid phone number'
                         },
                         uniqueness: true

      # @!attribute [rw] country_code
      #   The phone number country code (the first one or two digits).
      #
      #   @return [String, nil]
      attribute :country_code, :string
      validates :country_code, format: {
                                 with: /\A\d{1,2}\z/,
                                 message: 'must be a valid country code number'
                               },
                               allow_nil: true

      # @!attribute [rw] area_code
      #   The phone number area code (three digits after the country code).
      #
      #   @return [String, nil]
      attribute :area_code, :string
      validates :area_code, format: {
                              with: /\A\d{3}\z/,
                              message: 'must be a valid area code number'
                            },
                            allow_nil: true

      # @!attribute [rw] prefix
      #   The phone number prefix (three digits after the area code).
      #
      #   @return [String]
      attribute :prefix, :string
      validates :prefix, presence: true,
                         format:   {
                           with: /\A\d{3}\z/,
                           message: 'must be a valid prefix number'
                         }

      # @!attribute [rw] line_number
      #   The phone number line number (last four digits).
      #
      #   @return [String]
      attribute :line_number, :string
      validates :line_number, presence: true,
                              format:   {
                                with: /\A\d{4}\z/,
                                message: 'must be a valid line number'
                              }

      # @!attribute [rw] created_at
      #   Tracks when the phone number was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] personal_phone_numbers
      #   The association of people that use this phone number.
      #
      #   @return [Array<PersonalPhoneNumber>]
      has_many :personal_phone_numbers, dependent: :destroy

      # @!attribute [rw] people
      #   The people that use this phone number.
      #
      #   @return [Array<Person>]
      has_many :people, through: :personal_phone_numbers

      # @!attribute [rw] organization_department
      #   The organization department that uses the email address.
      #
      #   @return [OrganizationDepartment, nil]
      has_one :organization_department, dependent: :nullify

      # @!attribute [rw] organization_members
      #   The organization member that use the phone number.
      #
      #   @return [OrganizationMember, nil]
      has_one :organization_member, dependent: :nullify

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      has_many :notes, dependent: :destroy

      #
      # Looks up the phone number.
      #
      # @param [String] number
      #   The phone number to query.
      #
      # @return [PhoneNumber, nil]
      #   The found phone number.
      #
      # @api public
      #
      def self.lookup(number)
        find_by(number: number)
      end

      #
      # Parses the phone number.
      #
      # @param [String] number
      #   The raw phone number to parse.
      #
      # @return [Hash{Symbol => String,nil}]
      #   The parsed attributes of the phone number.
      #
      # @api private
      #
      def self.parse(number)
        if (match = number.match(/\A(?:\+?(?<country_code>\d{1,2})[\s.-])?(?:(?:\((?<area_code>\d{3})\)|(?<area_code>\d{3}))[\s.-])?(?<prefix>\d{3})[\s.-](?<line_number>\d{4})\z/))
          {
            number: number,

            country_code: match[:country_code],
            area_code:    match[:area_code],
            prefix:       match[:prefix],
            line_number:  match[:line_number]
          }
        else
          raise(ArgumentError,"invalid phone number: #{number.inspect}")
        end
      end

      #
      # Imports an phone number.
      #
      # @param [String] number
      #   The phone number to import.
      #
      # @return [PhoneNumber]
      #   The imported phone number.
      #
      # @api public
      #
      def self.import(number)
        create(parse(number))
      end

      #
      # Converts the phone number to a String.
      #
      # @return [String]
      #
      def to_s
        number
      end

    end
  end
end

require 'ronin/db/personal_phone_number'
require 'ronin/db/person'
require 'ronin/db/organization_department'
require 'ronin/db/organization_member'
require 'ronin/db/note'
