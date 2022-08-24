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
    # Represents a HTTP header belonging to an HTTP response.
    #
    class HTTPResponseHeader < ActiveRecord::Base

      include Model

      # The primary ID of the HTTP response header.
      attribute :id, :integer

      # The name of the HTTP response header.
      belongs_to :name, required:   true,
                        class_name: 'HTTPHeaderName'

      # The value of the HTTP response header.
      attribute :value, :string
      validates :value, presence: true

      # The associated HTTP response that the HTTP response header belongs to.
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

require 'ronin/db/http_header_name'
require 'ronin/db/http_response'
