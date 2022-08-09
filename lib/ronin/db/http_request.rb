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
    # Represents a HTTP request.
    #
    class HTTPRequest < ActiveRecord::Base

      include Model

      attribute :id, :integer

      attribute :version, :string
      validates :version, presence: true,
                          inclusion: {in: %w[1.0 1.1 2.0]}

      enum request_method: [
        :copy,
        :delete,
        :get,
        :head,
        :lock,
        :mkcol,
        :move,
        :options,
        :patch,
        :post,
        :propfind,
        :proppatch,
        :put,
        :trace,
        :unlock
      ], _suffix: :requests
      validates :request_method, presence: true

      attribute :path, :string
      validates :path, presence: true

      attribute :query, :string

      has_many :query_param, foreign_key: 'request_id',
                             class_name: 'HTTPQueryParam',
                             dependent:  :destroy

      attribute :body, :text

      has_many :headers, foreign_key: 'request_id',
                         class_name:  'HTTPRequestHeader',
                         dependent:   :destroy

      belongs_to :response, class_name: 'HTTPResponse',
                            dependent:  :destroy

      attribute :created_at, :time

    end
  end
end
