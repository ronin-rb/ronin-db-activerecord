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
    # Represents a TCP or UDP port.
    #
    class Port < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the port.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] protocol
      #   The protocol of the port (either `'tcp'` / `'udp'`).
      #
      #   @return ["tcp", "udp"]
      enum :protocol, {tcp: 'tcp', udp: 'udp'}, default: :tcp
      validates :protocol, presence: true

      # @!attribute [rw] number
      #   The port number.
      #
      #   @return [Integer]
      attribute :number, :integer
      validates :number, presence: true,
                         numericality: {
                           greater_than_or_equal_to: 1,
                           less_than_or_equal_to:    65535
                         },
                         uniqueness: {scope: :protocol}

      # @!attribute [rw] open_ports
      #   The open ports.
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports, dependent: :destroy

      #
      # Looks up a port by it's number.
      #
      # @param [String, Integer] number
      #   The port number to query.
      #
      # @return [Port, nil]
      #   The found port number.
      #
      # @api public
      #
      def self.lookup(number)
        find_by(number: number)
      end

      #
      # Creates a new Port.
      #
      # @param [String, Integer] number
      #   The port number.
      #
      # @return [Port]
      #   The new or previously saved port.
      #
      # @api public
      #
      def self.import(number)
        create(number: number)
      end

      #
      # Converts the port to an integer.
      #
      # @return [Integer]
      #   The port number.
      #
      # @api public
      #
      def to_i
        self.number.to_i
      end

      #
      # Converts the port to a string.
      #
      # @return [String]
      #   The port number and protocol.
      #
      # @api public
      #
      def to_s
        "#{self.number}/#{self.protocol}"
      end

    end
  end
end

require 'ronin/db/open_port'
