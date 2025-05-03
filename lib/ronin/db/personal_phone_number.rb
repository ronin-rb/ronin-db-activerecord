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
    # Represents a {PhoneNumber} that belongs to a {Person}.
    #
    # @since 0.2.0
    #
    class PersonalPhoneNumber < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the personal phone number.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The type of the phone number.
      #
      #   @return ["home", "cell", "fax", "voip", nil]
      attribute :type, :string
      validates :type, allow_nil: true,
                       inclusion: {
                         in: %w[
                           home
                           cell
                           fax
                           voip
                         ]
                       }

      # @!attribute [rw] person
      #   The person who owns the phone number.
      #
      #   @return [Person]
      belongs_to :person

      # @!attribute [rw] phone_number
      #   The phone number.
      #
      #   @return [PhoneNumber]
      belongs_to :phone_number
      validates :phone_number, uniqueness: {scope: [:type, :person_id]}

      # @!attribute [rw] created_at
      #   Tracks when the personal phone number was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      #
      # Determines if the personal phone number is a home number.
      #
      # @return [Boolean]
      #
      def home?
        self.type == 'home'
      end

      #
      # Determines if the personal phone number is a cell number.
      #
      # @return [Boolean]
      #
      def cell?
        self.type == 'cell'
      end

      #
      # Determines if the personal phone number is a Fax number.
      #
      # @return [Boolean]
      #
      def fax?
        self.type == 'fax'
      end

      #
      # Determines if the personal phone number is a VoIP number.
      #
      # @return [Boolean]
      #
      def voip?
        self.type == 'voip'
      end

    end
  end
end

require_relative 'person'
require_relative 'phone_number'
