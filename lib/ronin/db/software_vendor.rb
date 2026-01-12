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
require_relative 'model/has_unique_name'

module Ronin
  module DB
    #
    # Represents a {Software} vendor.
    #
    class SoftwareVendor < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      # @!attribute [rw] id
      #   The primary-key of the vendor
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] software
      #   Products published by the vendor
      #
      #   @return [Array<Software>]
      has_many :software, class_name: 'Software',
                          foreign_key: :vendor_id

    end
  end
end
