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
require_relative 'model/importable'
require_relative 'model/last_scanned_at'

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
      include Model::Importable
      include Model::LastScannedAt

      # @!attribute [rw] id
      #   The primary ID of the host name.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The address of the host name.
      #
      #   @return [String]
      attribute :name, :string
      validates :name, presence: true,
                       uniqueness: true,
                       length: {maximum: 255},
                       format: {
                         with: /\A#{URI::RFC2396_REGEXP::PATTERN::HOSTNAME}\z/,
                         message: 'Must be a valid host-name'
                       }

      # @!attribute [rw] created_at
      #   When the host name was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] host_name_ip_addresses
      #   The IP Address associations.
      #
      #   @return [Array<HostNameIPAddress>]
      has_many :host_name_ip_addresses, dependent: :destroy,
                                        class_name: 'HostNameIPAddress'

      # @!attribute [rw] ip_addresses
      #   The IP Addresses that host the host name.
      #
      #   @return [Array<IPAddress>]
      has_many :ip_addresses, through:    :host_name_ip_addresses,
                              class_name: 'IPAddress'

      # @!attribute [rw] open_ports
      #   The open ports of the host.
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports, through: :ip_addresses

      # @!attribute [rw] ports
      #   The ports of the host.
      #
      #   @return [Array<Port>]
      has_many :ports, through: :ip_addresses

      # @!attribute [rw] email_addresses
      #   The email addresses that are associated with the host-name.
      #
      #   @return [Array<EmailAddress>]
      has_many :email_addresses, dependent: :destroy

      # @!attribute [rw] urls
      #   The URLs that point to this host name.
      #
      #   @return [Array<URL>]
      has_many :urls, dependent: :destroy,
                      class_name: 'URL'

      # @!attribute [rw] vulnerabilities
      #   The vulnerabilities which reference the host name.
      #
      #   @return [Array<Vulnerability>]
      #
      #   @since 0.2.0
      has_many :vulnerabilities, dependent: :destroy

      # @!attribute [rw] advisories
      #   The advisories that the host names is vulnerable to.
      #
      #   @return [Array<Advisory>]
      #
      #   @since 0.2.0
      has_many :advisories, through: :vulnerabilities

      # @!attribute [rw] organization_host_names
      #   The association of host names and organizations.
      #
      #   @return [Array<OrganizationHostName>]
      #
      #   @since 0.2.0
      has_many :organization_host_names, dependent: :destroy

      # @!attribute [rw] organizations
      #   The organizations that claim ownership of the host name.
      #
      #   @return [Array<Organization>]
      #
      #   @since 0.2.0
      has_many :organizations, through: :organization_host_names

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # Looks up the host name.
      #
      # @param [String] name
      #   The raw host name.
      #
      # @return [HostName, nil]
      #   The found host name.
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Creates a new host name.
      #
      # @param [String] name
      #   The host name.
      #
      # @return [HostName]
      #   The created host name record.
      #
      def self.import(name)
        create(name: name)
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
      def self.with_port_number(number)
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
      # @return [IPAddress]
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

require_relative 'host_name_ip_address'
require_relative 'ip_address'
require_relative 'vulnerability'
require_relative 'advisory'
require_relative 'organization_host_name'
require_relative 'note'
