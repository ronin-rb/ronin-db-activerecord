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

      # @!attribute [rw] open_ports
      #   The open ports running the service
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports

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
