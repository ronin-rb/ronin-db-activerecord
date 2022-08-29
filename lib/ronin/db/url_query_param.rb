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

require 'active_record'
require 'uri/query_params'

module Ronin
  module DB
    #
    # Represents a query param that belongs to a {URL}.
    #
    class URLQueryParam < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary-key of the URL query param
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The name of the URL query param.
      #
      #   @return [URLQueryParamName]
      belongs_to :name, required:   true,
                        class_name: 'URLQueryParamName'
      validates :name_id, uniqueness: {scope: :url_id}

      # @!attribute [rw] value
      #   The value of the URL query param
      #
      #   @return [String]
      attribute :value, :text

      # @!attribute [rw] url
      #   The URL that the query param belongs to.
      #
      #   @return [URL]
      belongs_to :url, required:   true,
                       class_name: 'URL'

      #
      # Converts the URL query param to a String.
      #
      # @return [String]
      #   The dumped URL query param.
      #
      # @api public
      #
      def to_s
        URI::QueryParams.dump(self.name.to_s => self.value)
      end

    end
  end
end

require 'ronin/db/url_query_param_name'
require 'ronin/db/url'
