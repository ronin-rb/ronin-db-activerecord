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

require 'active_record'

module Ronin
  module DB
    #
    # Represents a DNS record.
    #
    # @since 0.2.0
    #
    class DNSRecord < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID for the DNS record.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] ttl
      #   The Time-To-Live (TTL) for the DNS record.
      #
      #   @return [Integer]
      attribute :ttl, :integer
      validates :ttl, presence: true

      # @!attribute [rw] value
      #   The value of the DNS record.
      #
      #   @return [String]
      attribute :value, :string
      validates :value, presence: true,
                        length:   {maximum: 255}

      # @!attribute [rw] dns_query
      #   The DNS query that the record belongs to.
      #
      #   @return [DNSQuery]
      belongs_to :dns_query

      #
      # Converts the DNS records into a String.
      #
      # @return [String]
      #
      def to_s
        value
      end

    end
  end
end

require_relative 'dns_query'
