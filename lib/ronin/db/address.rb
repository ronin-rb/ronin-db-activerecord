# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/db/model/last_scanned_at'

require 'active_record'

module Ronin
  module DB
    #
    # A base model which represents an Internet Address, such as:
    #
    # * {MACAddress}
    # * {IPAddress}
    # * {HostName}
    #
    class Address < ActiveRecord::Base

      include Model
      include Model::Importable
      include Model::LastScannedAt

      self.abstract_class = true

      # @!attribute [rw] id
      #   The primary key of the Address
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] address
      #   The Address
      #
      #   @return [String]
      attribute :address, :string
      validates :address, presence: true, uniqueness: true

      # @!attribute [rw] created_at
      #   Tracks when the IP Address was first created
      #
      #   @return [Time]
      attribute :created_at, :time

      #
      # Looks up the address.
      #
      # @param [String] address
      #   The address to query.
      #
      # @return [Address, nil]
      #   The found address.
      #
      def self.lookup(address)
        find_by(address: address)
      end

      #
      # Imports an address.
      #
      # @param [String] address
      #   The address to parse.
      #
      # @return [Address]
      #   The parsed address.
      #
      # @api public
      #
      def self.import(address)
        create(address: address)
      end

      #
      # Converts the address into a string.
      #
      # @return [String]
      #   The address.
      #
      # @api public
      #
      def to_s
        self.address.to_s
      end

    end
  end
end
