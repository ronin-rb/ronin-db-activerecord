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

require 'ronin/db/model'
require 'ronin/db/model/last_scanned_at'

require 'active_record'
require 'uri/rfc2396_parser'
require 'strscan'

module Ronin
  module DB
    #
    # Represents host names and their associated {IPAddress IP addresses}.
    #
    class HostName < ActiveRecord::Base

      include Model
      include Model::LastScannedAt

      # Primary ID
      attribute :id, :integer

      # The address of the host name
      attribute :name, :string
      validates :name, presence: true,
                       uniqueness: true,
                       length: {maximum: 255},
                       format: {
                         with: /\A#{URI::RFC2396_REGEXP::PATTERN::HOSTNAME}\z/,
                         message: 'Must be a valid host-name'
                       }

      # When the host name was first created
      attribute :created_at, :time

      # The IP Address associations
      has_many :host_name_ip_addresses, dependent: :destroy,
                                        class_name: 'HostNameIPAddress'

      # The IP Addresses that host the host name
      has_many :ip_addresses, through:    :host_name_ip_addresses,
                              class_name: 'IPAddress'

      # Open ports of the host
      has_many :open_ports, through: :ip_addresses

      # Ports of the host
      has_many :ports, through: :ip_addresses

      # The email addresses that are associated with the host-name.
      has_many :email_addresses

      # URLs that point to this host name
      has_many :urls, class_name: 'URL'

      #
      # Parses the host name.
      #
      # @param [String] name
      #   The host name to parse.
      #
      # @return [HostName]
      #   The new or previously saved host name record.
      #
      # @api public
      #
      def self.parse(name)
        find_or_initialize_by(name: name)
      end

      #
      # Searches for host names associated with the given IP address(es).
      #
      # @param [Array<String>, String] ip
      #   The IP address(es) to search for.
      #
      # @return [Array<HostName>]
      #   The matching host names.
      #
      # @api public
      #
      def self.with_ip_address(ip)
        joins(:ip_addresses).where(ip_addresses: {address: ip})
      end

      #
      # Searches for host names with the given open port(s).
      #
      # @param [Array<Integer>, Integer] number
      #   The open port(s) to search for.
      #
      # @return [Array<HostName>]
      #   The matching host names.
      #
      # @api public
      #
      def self.with_port(number)
        joins(:ports).where(ports: {number: number})
      end

      #
      # Searches for all host names under the Top-Level Domain (TLD).
      #
      # @param [String] name
      #   The Top-Level Domain (TLD).
      #
      # @return [Array<HostName>]
      #   The matching host names.
      #
      # @api public
      #
      def self.with_tld(name)
        name_column = self.arel_table[:name]

        where(name_column.matches("%.#{sanitize_sql_like(name)}"))
      end

      #
      # Searches for all host names sharing a canonical domain name.
      #
      # @param [String] name
      #   The canonical domain name to search for.
      #
      # @return [Array<HostName>]
      #   The matching host names.
      #
      # @api public
      #
      def self.with_domain(name)
        name_column = self.arel_table[:name]

        name = sanitize_sql_like(name)

        where(name: name).or(where(name_column.matches("%.#{name}")))
      end

      #
      # The IP Address that was most recently used by the host name.
      #
      # @return [IpAddress]
      #   The IP Address that most recently used by the host name.
      #
      # @api public
      #
      def recent_ip_address
        self.host_name_ip_addresses.order('created_at DESC').ip_addresses.first
      end

      #
      # Converts the host name to a String.
      #
      # @return [String]
      #   The host name.
      #
      # @api public
      #
      def to_s
        self.name.to_s
      end

    end
  end
end

require 'ronin/db/host_name_ip_address'
require 'ronin/db/ip_address'
