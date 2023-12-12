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
      enum request_method: {
        copy:      'COPY',
        delete:    'DELETE',
        get:       'GET',
        head:      'HEAD',
        lock:      'LOCK',
        mkcol:     'MKCOL',
        move:      'MOVE',
        options:   'OPTIONS',
        patch:     'PATCH',
        post:      'POST',
        propfind:  'PROPFIND',
        proppatch: 'PROPPATCH',
        put:       'PUT',
        trace:     'TRACE',
        unlock:    'UNLOCK'
      }, _suffix: :requests
      validates :request_method, presence: true

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

    end
  end
end
