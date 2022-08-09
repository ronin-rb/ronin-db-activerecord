#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-db-activerecord.
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

      attribute :id, :integer

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

      has_many :headers, foreign_key: :request_id,
                         class_name:  'HTTPResponseHeader',
                         dependent:   :destroy

      attribute :body, :text

      attribute :created_at, :time

      has_one :request, required:   true,
                        foreign_key: :response_id,
                        class_name: 'HTTPRequest'

    end
  end
end

require 'ronin/db/http_request'
