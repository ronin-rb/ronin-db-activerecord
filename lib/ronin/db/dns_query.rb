# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'active_record'
require 'resolv'

module Ronin
  module DB
    #
    # Represents a DNS query.
    #
    # @since 0.2.0
    #
    class DNSQuery < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID for the DNS query.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The queried record type.
      #
      #   @return [String]
      attribute :type, :string
      validates :type, presence: true,
                       inclusion: {
                         in: %w[
                           A
                           AAAA
                           ANY
                           CNAME
                           HINFO
                           LOC
                           MX
                           NS
                           PTR
                           SOA
                           SRV
                           TXT
                           WKS
                         ]
                       }

      # @!attribute [rw] label
      #   The queried domain label.
      #
      #   @return [String]
      attribute :label, :string
      validates :label, presence: true

      # @!attribute [rw] source_addr
      #   The source IP Address.
      #
      #   @return [String]
      attribute :source_addr, :string
      validates :source_addr, presence: true,
                              length: { maximum: 39 },
                              format: {
                                with: /#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/,
                                message: 'Must be a valid IP address'
                              }

      # @!attribute [rw] created_at
      #   When the DNS query request was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] records
      #   The optional DNS records associated with the DNS query.
      #
      #   @return [Array<DNSRecord>]
      has_many :records, class_name: 'DNSRecord'

      #
      # Determines if the DNS query is an A record query.
      #
      # @return [Boolean]
      #
      def a_query?
        self.type == 'A'
      end

      #
      # Determines if the DNS query is an AAAA record query.
      #
      # @return [Boolean]
      #
      def aaaa_query?
        self.type == 'AAAA'
      end

      #
      # Determines if the DNS query is an ANY record query.
      #
      # @return [Boolean]
      #
      def any_query?
        self.type == 'ANY'
      end

      #
      # Determines if the DNS query is an CNAME record query.
      #
      # @return [Boolean]
      #
      def cname_query?
        self.type == 'CNAME'
      end

      #
      # Determines if the DNS query is an HINFO record query.
      #
      # @return [Boolean]
      #
      def hinfo_query?
        self.type == 'HINFO'
      end

      #
      # Determines if the DNS query is an LOC record query.
      #
      # @return [Boolean]
      #
      def loc_query?
        self.type == 'LOC'
      end

      #
      # Determines if the DNS query is an MX record query.
      #
      # @return [Boolean]
      #
      def mx_query?
        self.type == 'MX'
      end

      #
      # Determines if the DNS query is an NS record query.
      #
      # @return [Boolean]
      #
      def ns_query?
        self.type == 'NS'
      end

      #
      # Determines if the DNS query is an PTR record query.
      #
      # @return [Boolean]
      #
      def ptr_query?
        self.type == 'PTR'
      end

      #
      # Determines if the DNS query is an SOA record query.
      #
      # @return [Boolean]
      #
      def soa_query?
        self.type == 'SOA'
      end

      #
      # Determines if the DNS query is an SRV record query.
      #
      # @return [Boolean]
      #
      def srv_query?
        self.type == 'SRV'
      end

      #
      # Determines if the DNS query is an TXT record query.
      #
      # @return [Boolean]
      #
      def txt_query?
        self.type == 'TXT'
      end

      #
      # Determines if the DNS query is an WKS record query.
      #
      # @return [Boolean]
      #
      def wks_query?
        self.type == 'WKS'
      end

    end
  end
end

require_relative 'dns_record'
