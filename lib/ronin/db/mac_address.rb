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

require_relative 'address'

require 'active_record'
require 'strscan'

module Ronin
  module DB
    #
    # Represents MAC addresses and their associated {IPAddress IP addresses}.
    #
    class MACAddress < Address

      # @!attribute [rw] address
      #   The MAC address.
      #
      #   @return [String]
      attribute :address, :string
      validates :address, presence:   true,
                          uniqueness: true,
                          length: {maximum: 17},
                          format: {
                            with: /\A[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}\z/,
                            message: 'Must be a valid MAC address'
                          }

      # @!attribute [rw] ip_address_mac_addresses
      #   The IP Addresses the MAC Address hosts
      #
      #   @return [Array<IPAddressMACAddress>]
      has_many :ip_address_mac_addresses, dependent: :destroy,
                                          class_name: 'IPAddressMACAddress'

      # @!attribute [rw] ip_addresses
      #   The IP Addresses associated with the MAC Address
      #
      #   @return [Array<IPAddress>]
      has_many :ip_addresses, through:    :ip_address_mac_addresses,
                              class_name: 'IPAddress'

      # @!attribute [rw] vulnerabilities
      #   The vulnerabilities which reference the MAC Address.
      #
      #   @return [Array<Vulnerability>]
      #
      #   @since 0.2.0
      has_many :vulnerabilities, dependent: :destroy

      # @!attribute [rw] advisories
      #   The advisories that the MAC Address is vulnerable to.
      #
      #   @return [Array<Advisory>]
      #
      #   @since 0.2.0
      has_many :advisories, through: :vulnerabilities

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # The IP Address that most recently used the MAC Address.
      #
      # @return [IPAddress]
      #   The IP Address that most recently used the MAC Address.
      #
      # @api public
      #
      def recent_ip_address
        self.ip_address_mac_addresses.order('created_at DESC').ip_addresses.first
      end

      #
      # Converts the MAC address to an Integer.
      #
      # @return [Integer]
      #   The network representation of the MAC address.
      #
      # @api public
      #
      def to_i
        self.address.split(':').reduce(0) do |bits,char|
          ((bits << 8) | char.hex)
        end
      end

    end
  end
end

require_relative 'ip_address_mac_address'
require_relative 'ip_address'
require_relative 'vulnerability'
require_relative 'advisory'
require_relative 'note'
