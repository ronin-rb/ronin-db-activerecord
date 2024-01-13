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

      # @!attribute [rw] address
      #   The IP Address.
      #
      #   @return [String]
      attribute :address, :string
      validates :address, presence: true,
                          uniqueness: true,
                          length: {maximum: 39},
                          format: {
                            with: /#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/,
                            message: 'Must be a valid IP address'
                          }

      # @!attribute [rw] hton
      #   The IP address, but in network byte-order.
      #
      #   @return [String]
      attribute :hton, :binary
      before_save :set_hton

      # @!attribute [rw] version
      #   Type of the address.
      #
      #   @return [Integer]
      attribute :version, :integer
      validates :version, inclusion: {in: [4, 6]}

      # @!attribute [rw] ip_address_mac_addresses
      #   The MAC Addresses associations.
      #
      #   @return [Array<IPAddressMACAddress>]
      has_many :ip_address_mac_addresses, dependent:  :destroy,
                                          class_name: 'IPAddressMACAddress'

      # @!attribute [rw] mac_addresses
      #   The MAC Addresses associated with the IP Address.
      #
      #   @return [Array<MACAddress>]
      has_many :mac_addresses, through: :ip_address_mac_addresses,
                               class_name: 'MACAddress'

      # @!attribute [rw] host_name_ip_addresses
      #   The host-names that the IP Address serves.
      #
      #   @return [Array<HostNameIPAddress>]
      has_many :host_name_ip_addresses, dependent: :destroy,
                                        class_name: 'HostNameIPAddress'

      # @!attribute [rw] host_names
      #   The host-names associated with the IP Address.
      #
      #   @return [Array<HostName>]
      has_many :host_names, through: :host_name_ip_addresses

      # @!attribute [rw] open_ports
      #   The open ports of the host.
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports, dependent: :destroy

      # @!attribute [rw] ports
      #   The ports of the host.
      #
      #   @return [Array<Port>]
      has_many :ports, through: :open_ports

      # @!attribute [rw] os_guesses
      #   Any OS guesses against the IP Address.
      #
      #   @return [Array<OSGuess>]
      has_many :os_guesses, dependent: :destroy,
                            class_name: 'OSGuess'

      # @!attribute [rw] oses
      #   Any OSes that the IP Address might be running
      #
      #   @return [Array<OS>]
      has_many :oses, through: :os_guesses,
                      class_name: 'OS'

      # @!attribute [rw] vulnerabilities
      #   The vulnerabilities which reference the IP Address.
      #
      #   @return [Array<Vulnerability>]
      #
      #   @since 0.2.0
      has_many :vulnerabilities, dependent: :destroy

      # @!attribute [rw] advisories
      #   The advisories that the IP Address is vulnerable to.
      #
      #   @return [Array<Advisory>]
      #
      #   @since 0.2.0
      has_many :advisories, through: :vulnerabilities

      # @!attribute [rw] organization_ip_addresses
      #   The association of IP addresses and organizations.
      #
      #   @return [Array<OrganizationIPAddress>]
      #
      #   @since 0.2.0
      has_many :organization_ip_addresses, class_name: 'OrganizationIPAddress',
                                           dependent:  :destroy

      # @!attribute [rw] organizations
      #   The organizations that claim ownership of the IP address.
      #
      #   @return [Array<Organization>]
      #
      #   @since 0.2.0
      has_many :organizations, through: :organization_ip_addresses

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

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
      # Queries all IP address that are between the first IP address and last IP
      # address.
      #
      # @param [String] first_ip
      #   The first IP of the IP range.
      #
      # @param [String] last_ip
      #   The last IP of the IP range.
      #
      # @return [Array<IPAddress>]
      #
      def self.between(first_ip,last_ip)
        first_ip_hton = IPAddr.new(first_ip).hton
        last_ip_hton  = IPAddr.new(last_ip).hton

        hton = arel_table[:hton]

        where(hton.gteq(first_ip_hton).and(hton.lteq(last_ip_hton)))
      end

      #
      # Queries all IP addresses that exist in the range of IP addresses.
      #
      # @param [Range, #begin, #end] range
      #   The IP range to query.
      #
      # @return [Array<IPAddress>]
      #
      def self.in_range(range)
        between(range.begin,range.end)
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
      # Initializes the IP address record.
      #
      # @param [Array] arguments
      #   Additional attribute arguments.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional attribute values.
      #
      # @note Also assigns a default value to `version` based on the `address`.
      #
      def initialize(*arguments,**kwargs)
        super(*arguments,**kwargs)

        self.version ||= if ipaddr
                           if ipaddr.ipv6? then 6
                           else                 4
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
        @ipaddr = nil
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
      def ipaddr
        @ipaddr ||= if self.address
                      begin
                        IPAddr.new(self.address)
                      rescue IPAddr::InvalidAddressError
                        nil
                      end
                    end
      end

      #
      # Queries the {ASN} record for the IP address.
      #
      # @return [ASN, nil]
      #
      def asn
        ASN.containing_ip(ipaddr)
      end

      #
      # The MAC Address that was most recently used by the IP Address.
      #
      # @return [MACAddress]
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

      alias to_ip ipaddr

      #
      # Converts the address to an Integer.
      #
      # @return [Integer]
      #   The network representation of the IP address.
      #
      # @api public
      #
      def to_i
        ipaddr.to_i
      end

      private

      #
      # Sets the `hton` attribute.
      #
      def set_hton
        self.hton = self.ipaddr.hton
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
require 'ronin/db/os_guess'
require 'ronin/db/os'
require 'ronin/db/asn'
require 'ronin/db/vulnerability'
require 'ronin/db/advisory'
require 'ronin/db/organization_ip_address'
require 'ronin/db/note'
