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
    # Represents a HTTP header belonging to an HTTP response.
    #
    class HTTPResponseHeader < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID of the HTTP response header.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The name of the HTTP response header.
      #
      #   @return [HTTPHeaderName]
      belongs_to :name, required:   true,
                        class_name: 'HTTPHeaderName'

      # @!attribute [rw] value
      #   The value of the HTTP response header.
      #
      #   @return [String]
      attribute :value, :string
      validates :value, presence: true

      # @!attribute [rw] response
      #   The associated HTTP response that the HTTP response header belongs to.
      #
      #   @return [HTTPResponse]
      belongs_to :response, required:   true,
                            class_name: 'HTTPResponse'

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
require_relative 'http_response'
