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
require 'resolv'

module Ronin
  module DB
    #
    # Represents a HTTP request.
    #
    class HTTPRequest < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID for the HTTP request.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] version
      #   The HTTP version of the HTTP request.
      #
      #   @return [String]
      attribute :version, :string
      validates :version, presence: true,
                          inclusion: {in: %w[1.0 1.1 2.0]}

      # @!attribute [rw] request_method
      #   The request method.
      #
      #   @return ["COPY", "DELETE", "GET", "HEAD", "LOCK", "MKCOL", "MOVE", "OPTIONS", "PATCH", "POST", "PROPFIND", "PROPPATCH", "PUT", "TRACE", "UNLOCK"]
      attribute :request_method, :string
      validates :request_method, presence: true,
                                 inclusion: {
                                   in: %w[
                                     COPY
                                     DELETE
                                     GET
                                     HEAD
                                     LOCK
                                     MKCOL
                                     MOVE
                                     OPTIONS
                                     PATCH
                                     POST
                                     PROPFIND
                                     PROPPATCH
                                     PUT
                                     TRACE
                                     UNLOCK
                                   ]
                                 }

      # @!attribute [rw] path
      #   The path of the HTTP request.
      #
      #   @return [String]
      attribute :path, :string
      validates :path, presence: true

      # @!attribute [rw] query
      #   The query string of the HTTP request.
      #
      #   @return [String, nil]
      attribute :query, :string

      # @!attribute [rw] query_params
      #   The additional parsed query params of the HTTP request.
      #
      #   @return [Array<HTTPQueryParam>]
      has_many :query_params, foreign_key: 'request_id',
                              class_name: 'HTTPQueryParam',
                              dependent:  :destroy
      # @!attribute [rw] body
      #   The optional body of the HTTP request.
      #
      #   @return [String, nil]
      attribute :body, :text

      # @!attribute [rw] headers
      #   The additional headers of HTTP request.
      #
      #   @return [Array<HTTPRequestHeader>]
      has_many :headers, foreign_key: 'request_id',
                         class_name:  'HTTPRequestHeader',
                         dependent:   :destroy

      # @!attribute [rw] response
      #   The optional HTTP response associated with the HTTP request.
      #
      #   @return [HTTPResponse, nil]
      belongs_to :response, class_name: 'HTTPResponse',
                            dependent:  :destroy

      # @!attribute [rw] created_at
      #   When the HTTP request was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] source_ip
      #   The source IP Address.
      #
      #   @return [String, nil]
      attribute :source_ip, :string
      validates :source_ip, length: { maximum: 39 },
                            format: {
                              with: /#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/,
                              message: 'Must be a valid IP address'
                            },
                            allow_nil: true

      #
      # Determines if the HTTP request is a COPY request.
      #
      # @return [Boolean]
      #
      def copy_request?
        self.request_method == 'COPY'
      end

      #
      # Determines if the HTTP request is a DELETE request.
      #
      # @return [Boolean]
      #
      def delete_request?
        self.request_method == 'DELETE'
      end

      #
      # Determines if the HTTP request is a GET request.
      #
      # @return [Boolean]
      #
      def get_request?
        self.request_method == 'GET'
      end

      #
      # Determines if the HTTP request is a HEAD request.
      #
      # @return [Boolean]
      #
      def head_request?
        self.request_method == 'HEAD'
      end

      #
      # Determines if the HTTP request is a LOCK request.
      #
      # @return [Boolean]
      #
      def lock_request?
        self.request_method == 'LOCK'
      end

      #
      # Determines if the HTTP request is a MKCOL request.
      #
      # @return [Boolean]
      #
      def mkcol_request?
        self.request_method == 'MKCOL'
      end

      #
      # Determines if the HTTP request is a MOVE request.
      #
      # @return [Boolean]
      #
      def move_request?
        self.request_method == 'MOVE'
      end

      #
      # Determines if the HTTP request is a OPTIONS request.
      #
      # @return [Boolean]
      #
      def options_request?
        self.request_method == 'OPTIONS'
      end

      #
      # Determines if the HTTP request is a PATCH request.
      #
      # @return [Boolean]
      #
      def patch_request?
        self.request_method == 'PATCH'
      end

      #
      # Determines if the HTTP request is a POST request.
      #
      # @return [Boolean]
      #
      def post_request?
        self.request_method == 'POST'
      end

      #
      # Determines if the HTTP request is a PROPFIND request.
      #
      # @return [Boolean]
      #
      def propfind_request?
        self.request_method == 'PROPFIND'
      end

      #
      # Determines if the HTTP request is a PROPPATCH request.
      #
      # @return [Boolean]
      #
      def proppatch_request?
        self.request_method == 'PROPPATCH'
      end

      #
      # Determines if the HTTP request is a PUT request.
      #
      # @return [Boolean]
      #
      def put_request?
        self.request_method == 'PUT'
      end

      #
      # Determines if the HTTP request is a TRACE request.
      #
      # @return [Boolean]
      #
      def trace_request?
        self.request_method == 'TRACE'
      end

      #
      # Determines if the HTTP request is a UNLOCK request.
      #
      # @return [Boolean]
      #
      def unlock_request?
        self.request_method == 'UNLOCK'
      end

    end
  end
end
