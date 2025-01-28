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

module Ronin
  module DB
    #
    # Represents a HTTP header sent in a HTTP request.
    #
    class HTTPRequestHeader < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID of the HTTP request header.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The name of the HTTP request header.
      #
      #   @return [HTTPHeaderName]
      belongs_to :name, required:   true,
                        class_name: 'HTTPHeaderName'

      # @!attribute [rw] value
      #   The value of the HTTP request header.
      #
      #   @return [String]
      attribute :value, :string
      validates :value, presence: true

      # @!attribute [rw] request
      #   The HTTP request that the header belongs to.
      #
      #   @return [HTTPRequest]
      belongs_to :request, required:   true,
                           class_name: 'HTTPRequest'

      #
      # Converts the HTTP request header to a String.
      #
      # @return [String]
      #   The header's name and value.
      #
      # @api public
      #
      def to_s
        "#{self.name}: #{self.value}"
      end

    end
  end
end

require_relative 'http_header_name'
require_relative 'http_request'
