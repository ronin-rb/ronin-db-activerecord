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

require_relative 'model'

require 'active_record'
require 'uri/query_params'

module Ronin
  module DB
    #
    # Represents a query param that belongs to a {HTTPRequest}.
    #
    class HTTPQueryParam < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary-key of the HTTP query param
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The name of the HTTP query param
      #
      #   @return [HTTPQueryParamName]
      belongs_to :name, required:   true,
                        class_name: 'HTTPQueryParamName'
      validates :name_id, uniqueness: {scope: :request_id}

      # @!attribute [rw] value
      #   The value of the HTTP query param
      #
      #   @return [String]
      attribute :value, :text

      # @!attribute [rw] request
      #   The HTTP request which contains this HTTP query param.
      #
      #   @return [HTTPRequest]
      belongs_to :request, required:   true,
                           class_name: 'HTTPRequest'

      #
      # Converts the HTTP query param to a String.
      #
      # @return [String]
      #   The dumped HTTP query param.
      #
      # @api public
      #
      def to_s
        URI::QueryParams.dump(self.name.to_s => self.value)
      end

    end
  end
end

require_relative 'http_query_param_name'
require_relative 'http_request'
