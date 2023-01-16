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
    # Represents a HTTP response.
    #
    class HTTPResponse < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary ID of the HTTP response.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] status
      #   The HTTP status code of the response.
      #
      #   @return [Integer]
      attribute :status, :integer
      validates :status, presence: true,
                         inclusion: {
                           in: [
                             100, 101, 103,
                             200, 201, 202, 203, 204, 206, 207, 208, 226,
                             300, 301, 302, 303, 304, 305, 306, 307, 308,
                             400, 401, 402, 403, 404, 405, 406, 407, 408, 409,
                             410, 411, 412, 413, 414, 415, 416, 417, 418,
                             421, 422, 423, 424, 425, 426, 428, 429,
                             431, 451,
                             500, 501, 502, 503, 504, 505, 506, 507, 508, 511
                           ]
                         }

      # @!attribute [rw] headers
      #   The associated headers of the HTTP response.
      #
      #   @return [Array<HTTPResponseHeader>]
      has_many :headers, foreign_key: :request_id,
                         class_name:  'HTTPResponseHeader',
                         dependent:   :destroy

      # @!attribute [rw] body
      #   The optional body of the HTTP response.
      #
      #   @return [String, nil]
      attribute :body, :text

      # @!attribute [r] created_at
      #   When the HTTP response was created.
      #
      #   @return [Time]
      attribute :created_at, :time

      # @!attribute [rw] request
      #   The associated HTTP request that the response was returned for.
      #
      #   @return [HTTPRequest]
      has_one :request, required:   true,
                        foreign_key: :response_id,
                        class_name: 'HTTPRequest'

    end
  end
end

require 'ronin/db/http_request'
