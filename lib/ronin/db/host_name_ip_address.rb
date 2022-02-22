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
    # Associates a {HostName} with an {IPAddress}.
    #
    class HostNameIPAddress < ActiveRecord::Base

      include Model

      # self.table_name = 'ronin_host_name_ip_addresses'

      # The primary-key of the join model.
      attribute :id, :integer

      # The host name pointing to the IP Address
      belongs_to :host_name, required: true,
                             inverse_of: :host_name_ip_addresses

      # The IP Address
      belongs_to :ip_address, required:   true,
                              inverse_of: :host_name_ip_addresses,
                              class_name: 'IPAddress'

      # Tracks when a IP Address is associated with a host name
      attribute :created_at, :time

    end
  end
end
