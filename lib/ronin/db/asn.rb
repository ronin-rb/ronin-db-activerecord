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
require_relative 'model/has_name'

module Ronin
  module DB
    #
    # Represents an ASN range.
    #
    class ASN < ActiveRecord::Base

      include Model
      extend Model::HasName::ClassMethods

      # @!attribute [rw] id
      #   The primary key of the ASN range.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] version
      #   Whether the ASN range represents an IPv4 or IPv6 range.
      #
      #   @return [Integer]
      attribute :version, :integer
      validates :version, presence:  true,
                          inclusion: {in: [4, 6]}

      # @!attribute [rw] range_start
      #   The starting IP address of the ASN range.
      #
      #   @return [String]
      attribute :range_start, :string
      validates :range_start, presence: true

      # @!attribute [rw] range_end
      #   The ending IP address of the ASN range.
      #
      #   @return [String]
      attribute :range_end, :string
      validates :range_end, presence: true

      # @!attribute [r] range_start_hton
      #   The starting IP address of the ASN range, but in network byte-order.
      #
      #   @return [String]
      attribute :range_start_hton, :binary

      # @!attribute [r] range_end_hton
      #   The ending IP address of the ASN range, but in network byte-order.
      #
      #   @return [String]
      attribute :range_end_hton, :binary

      before_save :set_hton

      # @!attribute [rw] number
      #   The ASN number.
      #
      #   @return [Integer]
      attribute :number, :integer
      validates :number, presence:   true,
                         uniqueness: {scope: [:range_start, :range_end]}

      # @!attribute [rw] country_code
      #   The country code of the ASN.
      #
      #   @return [String, nil]
      attribute :country_code, :string

      # @!attribute [rw] name
      #   The organization the ASN is currently assigned to.
      #
      #   @return [String, nil]
      attribute :name, :string

      #
      # Searches for all IPv4 ASNs.
      #
      # @return [Array<ASN>]
      #   The IPv4 ASNs.
      #
      # @api public
      #
      def self.v4
        where(version: 4)
      end

      #
      # Searches for all IPv6 ASNs.
      #
      # @return [Array<ASNs>]
      #   The IPv6 ASNs.
      #
      # @api public
      #
      def self.v6
        where(version: 6)
      end

      #
      # Searches for all ASNs with the matching AS number.
      #
      # @param [Integer] number
      #   The AS number to search for.
      #
      # @return [Array<ASN>]
      #
      def self.with_number(number)
        where(number: number)
      end

      #
      # Searches for all ASNs with the matching country code.
      #
      # @param [String] country_code
      #   The two letter country code to search for.
      #
      # @return [Array<ASN>]
      #
      def self.with_country_code(country_code)
        where(country_code: country_code)
      end

      #
      # Searches for all ASNs with the matching name.
      #
      # @param [String] name
      #   The name to search for.
      #
      # @return [Array<ASN>]
      #
      def self.with_name(name)
        where(name: name)
      end

      #
      # Queries the ASN that contains the given IP address.
      #
      # @param [IPAddr, String] ip
      #
      # @return [ASN, nil]
      #
      def self.containing_ip(ip)
        ip      = IPAddr.new(ip) unless ip.kind_of?(IPAddr)
        ip_hton = ip.hton

        range_start_hton = self.arel_table[:range_start_hton]
        range_end_hton   = self.arel_table[:range_end_hton]

        where(range_start_hton.lteq(ip_hton).and(range_end_hton.gteq(ip_hton))).first
      end

      #
      # @return [IPAddr, nil]
      #
      def range_start_ipaddr
        @range_start_ipaddr ||= if self.range_start
                                  IPAddr.new(self.range_start)
                                end
      end

      #
      # @return [IPAddr, nil]
      #
      def range_end_ipaddr
        @range_end_ipaddr ||= if self.range_end
                                IPAddr.new(self.range_end)
                              end
      end

      #
      # Queries all IP addresses within the ASN IP range.
      #
      # @return [Array<IPAddress>]
      #
      def ip_addresses
        IPAddress.between(range_start,range_end)
      end

      #
      # Converts the ASN to a String.
      #
      # @return [String]
      #   The `AS<number>` String.
      #
      # @since 0.2.0
      #
      def to_s
        "AS#{self.number}"
      end

      private

      #
      # Sets the `range_start_hton` and `range_end_hton` attributes.
      #
      def set_hton
        self.range_start_hton = range_start_ipaddr.hton
        self.range_end_hton   = range_end_ipaddr.hton
      end

    end
  end
end

require_relative 'ip_address'
