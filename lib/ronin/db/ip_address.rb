#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-db-activerecord.
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

require 'ronin/db/address'

require 'active_record'
require 'ipaddr'
require 'resolv'

module Ronin
  module DB
    #
    # Represents IP addresses and their associated {HostName host names}
    # and {MACAddress MAC addresses}.
    #
    class IPAddress < Address

      # The IP Address
      attribute :address, :string
      validates :address, presence: true,
                          uniqueness: true,
                          length: {maximum: 39},
                          format: {
                            with: /#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/,
                            message: 'Must be a valid IP address'
                          }

      # Type of the address
      attribute :version, :integer
      validates :version, inclusion: {in: [4, 6]}

      # The MAC Addresses associations
      has_many :ip_address_mac_addresses, dependent:  :destroy,
                                          class_name: 'IPAddressMACAddress'

      # The MAC Addresses associated with the IP Address
      has_many :mac_addresses, through: :ip_address_mac_addresses,
                               class_name: 'MACAddress'

      # The host-names that the IP Address serves
      has_many :host_name_ip_addresses, dependent: :destroy,
                                        class_name: 'HostNameIPAddress'

      # The host-names associated with the IP Address
      has_many :host_names, through: :host_name_ip_addresses

      # Open ports of the host
      has_many :open_ports, dependent: :destroy

      # Ports of the host
      has_many :ports, through: :open_ports

      # Any OS guesses against the IP Address
      has_many :os_guesses, dependent: :destroy,
                            class_name: 'OSGuess'

      # Any OSes that the IP Address might be running
      has_many :oses, through: :os_guesses,
                      class_name: 'OS'

      #
      # Initializes the IP address record.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional attribute values.
      #
      # @note Also assigns a default value to `version` based on the `address`.
      #
      def initialize(*arguments,**kwargs)
        super(*arguments,**kwargs)

        self.version ||= if ip_addr
                           if ip_addr.ipv6? then 6
                           else                  4
                           end
                         end
      end

      #
      # Sets the IP address'es address.
      #
      # @param [String, IPAddr, nil] new_address
      #   The new address to use.
      #
      # @return [String, IPAddr, nil]
      #   The IP address'es new address.
      #
      def address=(new_address)
        @ip_addr = nil
        super(new_address)
      end

      #
      # Returns an `IPAddr` object for the IP address.
      #
      # @return [IPAddr]
      #   The IPAddr object representing either the IPv4 or IPv6 address.
      #
      # @api public
      #
      def ip_addr
        @ip_addr ||= if self.address
                       begin
                         IPAddr.new(self.address)
                       rescue IPAddr::InvalidAddressError
                       end
                     end
      end

      #
      # Searches for all IPv4 addresses.
      #
      # @return [Array<IPAddress>]
      #   The IPv4 addresses.
      #
      # @api public
      #
      def self.v4
        where(version: 4)
      end

      #
      # Searches for all IPv6 addresses.
      #
      # @return [Array<IPAddress>]
      #   The IPv6 addresses.
      #
      # @api public
      #
      def self.v6
        where(version: 6)
      end

      #
      # Searches for all IP addresses associated with specific MAC address(es).
      #
      # @param [Array<String>, String] mac
      #   The MAC address(es) to search for.
      #
      # @return [Array<IPAddress>]
      #   The matching IP addresses.
      #
      # @api public
      #
      def self.with_mac_address(mac)
        joins(:mac_addresses).where(mac_addresses: {address: mac})
      end

      #
      # Searches for IP addresses associated with the given host name(s).
      #
      # @param [Array<String>, String] name
      #   The host name(s) to search for.
      #
      # @return [Array<IPAddress>]
      #   The matching IP addresses.
      #
      # @api public
      #
      def self.with_host_name(name)
        joins(:host_names).where(host_names: {name: name})
      end

      #
      # Searches for IP addresses with the given open port(s).
      #
      # @param [Array<Integer>, Integer] number
      #   The port number(s) to search for.
      #
      # @return [Array<IPAddress>]
      #   The matching IP addresses.
      #
      # @api public
      #
      def self.with_port_number(number)
        joins(:ports).where(ports: {number: number})
      end

      #
      # The MAC Address that was most recently used by the IP Address.
      #
      # @return [MacAddress]
      #   The MAC Address that most recently used the IP Address.
      #
      # @api public
      #
      def recent_mac_address
        self.ip_address_mac_addresses.order('created_at DESC').mac_addresses.first
      end

      #
      # The host-name that was most recently used by the IP Address.
      #
      # @return [HostName]
      #   The host-name that most recently used by the IP Address.
      #
      # @api public
      #
      def recent_host_name
        self.host_name_ip_addresses.order('created_at DESC').host_names.first
      end

      #
      # The Operating System that was most recently guessed for the IP
      # Address.
      #
      # @return [OS]
      #   The Operating System that most recently was guessed.
      #
      # @api public
      #
      def recent_os_guess
        self.os_guesses.order('created_at DESC').oses.first
      end

      alias to_ip ip_addr

      #
      # Converts the address to an Integer.
      #
      # @return [Integer]
      #   The network representation of the IP address.
      #
      # @api public
      #
      def to_i
        ip_addr.to_i
      end

    end
  end
end

require 'ronin/db/ip_address_mac_address'
require 'ronin/db/mac_address'
require 'ronin/db/host_name_ip_address'
require 'ronin/db/host_name'
require 'ronin/db/open_port'
require 'ronin/db/port'
require 'ronin/db/host_name'
require 'ronin/db/os_guess'
require 'ronin/db/os'
