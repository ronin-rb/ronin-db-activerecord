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
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents the name of a {HTTPQueryParam}.
    #
    class HTTPQueryParamName < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      # The primary-key of the HTTP query param
      attribute :id, :integer

      # The name of the HTTP query param
      attribute :name, :string # length:   256
      validates :name, presence: true, uniqueness: true

      # The HTTP query params
      has_many :query_params, class_name:  'HTTPQueryParam',
                              foreign_key: :name_id

      # When the HTTP query param name was first created.
      attribute :created_at, :time

      #
      # Converts the HTTP query param name to a String.
      #
      # @return [String]
      #   The name of the HTTP query param
      #
      # @api public
      #
      def to_s
        self.name.to_s
      end

    end
  end
end
