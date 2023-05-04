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
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a vulnerability Advisory, with a Publisher, Number and
    # URL.
    #
    class Advisory < ActiveRecord::Base

      include Model
      include Model::Importable

      self.primary_key = :id

      # @!attribute [rw] id
      #   Primary key of the advisory.
      #
      #   @return [String]
      attribute :id, :string

      # @!attribute [rw] prefix
      #   The ID prefix (ex: `CVE` or `GHSA`).
      #
      #   @return [String]
      attribute :prefix, :string
      validates :prefix, presence: true

      # @!attribute [rw] year
      #   The year the advisory was published in.
      #
      #   @return [Integer]
      attribute :year, :integer
      validates :year, allow_nil:  true,
                       comparison: {
                         greater_than: 1990,
                         less_than_or_equal_to: Date.today.year
                       }

      # @!attribute [rw] identifier
      #   The advisory identifier
      #
      #   @return [String]
      attribute :identifier, :string
      validates :identifier, presence: true

      # @!attribute [rw] vulnerabilities
      #   The vulnerabilities which reference the advisory.
      #
      #   @return [Array<Vulnerability>]
      #
      #   @since 0.2.0
      has_many :vulnerabilities, dependent: :destroy

      # @!attribute [rw] mac_addresses
      #   The MAC Addresses that are vulnerable to this advisory.
      #
      #   @return [Array<MACAddress>]
      #
      #   @since 0.2.0
      has_many :mac_addresses, through: :vulnerabilities

      # @!attribute [rw] ip_addresses
      #   The IP Addresses that are vulnerable to this advisory.
      #
      #   @return [Array<IPAddress>]
      #
      #   @since 0.2.0
      has_many :ip_addresses, through: :vulnerabilities

      # @!attribute [rw] open_ports
      #   The open ports that are vulnerable to this advisory.
      #
      #   @return [Array<OpenPort>]
      #
      #   @since 0.2.0
      has_many :open_ports, through: :vulnerabilities

      # @!attribute [rw] host_names
      #   The host names that are vulnerable to this advisory.
      #
      #   @return [Array<HostName>]
      #
      #   @since 0.2.0
      has_many :host_names, through: :vulnerabilities

      # @!attribute [rw] urls
      #   The URLs that are vulnerable to this advisory.
      #
      #   @return [Array<URL>]
      #
      #   @since 0.2.0
      has_many :urls, through: :vulnerabilities

      #
      # @api private
      #
      module ID
        #
        # Parses a security advisory ID.
        #
        # @param [String] string
        #   The security advisory ID String to split.
        #
        # @return [Hash{Symbol => Object}]
        #   The parsed security advisory ID.
        #
        # @raise [ArgumentError]
        #   The ID does not appear to be a valid security ID.
        #
        def self.parse(string)
          if    (match = string.match(/\A([A-Z]+)-(\d{4})[:-]([0-9][0-9-]+)\z/))
            {
              id:         match[0],
              prefix:     match[1],
              year:       match[2].to_i,
              identifier: match[3]
            }
          elsif (match = string.match(/\AMS(\d{2})-(\d{3,})\z/))
            {
              id:         match[0],
              prefix:     'MS',
              year:       2000 + match[1].to_i,
              identifier: match[2]
            }
          elsif (match = string.match(/\A([A-Z]+)-(.+)\z/))
            {
              id:         match[0],
              prefix:     match[1],
              identifier: match[2]
            }
          else
            raise(ArgumentError,"id does not appear to be a valid security advisory ID: #{string.inspect}")
          end
        end
      end

      #
      # Looks up the advisory.
      #
      # @param [String] id
      #
      # @return [Advisory, nil]
      #
      def self.lookup(id)
        find_by(id: id)
      end

      #
      # Parses an Advisory ID String.
      #
      # @param [String] id
      #   The ID String for the advisory.
      #
      # @return [Advisory]
      #   The new advisory.
      #
      # @api public
      #
      def self.import(id)
        create(**ID.parse(id))
      end

      #
      # Generates a URL for the advisory.
      #
      # @return [String, nil]
      #   The URL for the advisory.
      #
      # @api public
      #
      def url
        case prefix
        when 'CVE'  then "https://nvd.nist.gov/vuln/detail/#{id}"
        when 'RHSA' then "https://access.redhat.com/errata/#{id}"
        when 'GHSA' then "https://github.com/advisories/#{id}"
        end
      end

      #
      # Converts the advisory to a String.
      #
      # @return [String]
      #   The advisory ID string.
      #
      # @api public
      #
      def to_s
        self.id
      end

    end
  end
end

require 'ronin/db/vulnerability'
require 'ronin/db/mac_address'
require 'ronin/db/ip_address'
require 'ronin/db/open_port'
require 'ronin/db/host_name'
require 'ronin/db/url'
