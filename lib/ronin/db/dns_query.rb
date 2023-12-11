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

require 'active_record'
require 'resolv'

module Ronin
  module DB
    #
    # Represents a DNS query.
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
      enum type: {
        A:     'A',
        AAAA:  'AAAA',
        ANY:   'ANY',
        CNAME: 'CNAME',
        HINFO: 'HINFO',
        LOC:   'LOC',
        MX:    'MX',
        NS:    'NS',
        PTR:   'PTR',
        SOA:   'SOA',
        SRV:   'SRV',
        TXT:   'TXT',
        WKS:   'WKS'
      }
      validates :type, presence: true

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
      validates :source_addr, length: { maximum: 39 },
                              format: {
                                with: /#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/,
                                message: 'Must be a valid IP address'
                              }

      # @!attribute [rw] created_at
      #   When the DNS query request was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime
    end
  end
end
