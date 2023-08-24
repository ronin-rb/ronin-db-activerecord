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
require 'ronin/db/model/has_unique_name'
require 'ronin/db/model/importable'

module Ronin
  module DB
    #
    # Represents a TCP/UDP Service that runs on various common ports.
    #
    class Service < ActiveRecord::Base

      include Model
      include Model::Importable
      include Model::HasUniqueName

      # @!attribute [rw] id
      #   Primary key of the service
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [r] created_at
      #   Defines the created_at timestamp
      #
      #   @return [Time]
      #
      #   @since 0.2.0
      attribute :created_at, :datetime

      # @!attribute [rw] open_ports
      #   The open ports running the service
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports

      # @!attribute [rw] ip_addresses
      #   The IP Addresses that that run this service.
      #
      #   @return [Array<IPAddress>]
      #
      #   @since 0.2.0
      has_many :ip_addresses, through: :open_ports

      # @!attribute [rw] ports
      #   The ports that that use this service.
      #
      #   @return [Array<Port>]
      #
      #   @since 0.2.0
      has_many :ports, through: :open_ports

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # Queries all services associated with the port number.
      #
      # @param [Integer] number
      #   The port number to search by.
      #
      # @return [Array<Service>]
      #   The services associated with the port number.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.with_port_number(number)
        joins(open_ports: :port).where(
          open_ports: {
            ronin_ports: {number: number}
          }
        )
      end

      #
      # Looks up the service.
      #
      # @param [String] name
      #   The service name to lookup.
      #
      # @return [Service, nil]
      #   The found service.
      #
      # @since 0.2.0
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Imports a service.
      #
      # @param [String] name
      #   The service name to import.
      #
      # @return [Service]
      #   The imported service.
      #
      # @since 0.2.0
      #
      def self.import(name)
        create(name: name)
      end

    end
  end
end

require 'ronin/db/note'
