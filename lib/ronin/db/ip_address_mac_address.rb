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
    # Associates an {IPAddress} with a {MACAddress}.
    #
    class IPAddressMACAddress < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary-key of the join model.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] ip_address
      #   The IP Address.
      #
      #   @return [IPAddress]
      belongs_to :ip_address, required:   true,
                              class_name: 'IPAddress'

      # @!attribute [rw] mac_address
      #   The Mac Address.
      #
      #   @return [MACAddress]
      belongs_to :mac_address, required:   true,
                               class_name: 'MACAddress'

      # @!attribute [r] created_at
      #   Tracks when an IP Address becomes associated with a MAC Address.
      #
      #   @return [Time]
      attribute :created_at, :time

    end
  end
end
