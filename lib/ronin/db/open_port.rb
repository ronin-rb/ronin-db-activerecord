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
require 'ronin/db/model/last_scanned_at'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a open port at a specified IP address.
    #
    class OpenPort < ActiveRecord::Base

      include Model
      include Model::LastScannedAt

      # @!attribute [rw] id
      #   The primary key of the open port.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] ip_address
      #   The IP Address that was scanned.
      #
      #   @return [IPAddress]
      belongs_to :ip_address, required: true,
                              class_name: 'IPAddress'

      # @!attribute [rw] port
      #   The port.
      #
      #   @return [Port]
      belongs_to :port, required: true

      # @!attribute [rw] service
      #   The service detected on the port
      #
      #   @return [Service, nil]
      belongs_to :service, optional: true

      # @!attribute [rw] software
      #   The software running on the open port
      #
      #   @return [Software]
      belongs_to :software, optional: true

      # @!attribute [rw] ssl
      #   Specifies whether the service requires SSL.
      #
      #   @return [Boolean]
      attribute :ssl, :boolean

      # @!attribute [r] created_at
      #   Define the created_at timestamp
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] service_credentials
      #   Credentials used by the service running on the port
      #
      #   @return [Array<ServiceCredential>]
      has_many :service_credentials, dependent: :destroy

      # @!attribute [rw] credentials
      #   The credentials that will work with this open port.
      #
      #   @return [Array<Credential>]
      has_many :credentials, through: :service_credentials

      #
      # The IP Address of the open port.
      #
      # @return [String]
      #   The IP Address.
      #
      # @api public
      #
      def address
        self.ip_address.address
      end

      #
      # The port number.
      #
      # @return [Integer]
      #   The port number.
      #
      # @api public
      #
      def number
        self.port.number
      end

      #
      # Converts the open port to an integer.
      #
      # @return [Integer]
      #   The port number.
      #
      # @api public
      #
      def to_i
        self.port.to_i
      end

      #
      # Converts the open port to a string.
      #
      # @return [String]
      #   The information of the open port.
      #
      # @api public
      #
      def to_s
        if self.service then "#{self.port} (#{self.service})"
        else                 "#{self.port}"
        end
      end

    end
  end
end

require 'ronin/db/ip_address'
require 'ronin/db/port'
require 'ronin/db/service'
require 'ronin/db/service_credential'
