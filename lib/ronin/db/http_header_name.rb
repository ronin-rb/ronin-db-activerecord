# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a HTTP request or response Header name.
    #
    class HTTPHeaderName < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      # @!attribute [rw] id
      #   The primary key of the HTTP header name.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The Header name.
      #
      #   @return [String]
      attribute :name, :string # length: 256
      validates :name, presence: true, uniqueness: true

      # @!attribute [rw] http_request_headers
      #   The associated HTTP request headers.
      #
      #   @return [Array<HTTPRequestHeader>]
      has_many :http_request_headers

      # @!attribute [rw] http_requests
      #   The HTTP requests which contain this HTTP Header name.
      #
      #   @return [Array<HTTPRequest>]
      has_many :http_requests, through: :http_request_headers

      # @!attribute [rw] http_response_headers
      #   The associated HTTP response headers.
      #
      #   @return [Array<HTTPResponseHeader>]
      has_many :http_response_headers

      # @!attribute [rw] http_responses
      #   The HTTP responses which contain this HTTP Header name.
      #
      #   @return [Array<HTTPResponse>]
      has_many :http_responses, through: :http_response_headers

    end
  end
end
