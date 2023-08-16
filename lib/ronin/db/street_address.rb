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

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      has_many :notes

      #
      # Alias for {#state}.
      #
      # @return [String, nil]
      #
      # @see state
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

require 'ronin/db/note'