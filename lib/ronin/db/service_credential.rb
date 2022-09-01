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

require 'ronin/db/credential'

module Ronin
  module DB
    #
    # Represents Credentials used to access a TCP/UDP {Service}.
    #
    class ServiceCredential < Credential

      # @!attribute [rw] open_port
      #   The open port the credential belongs to.
      #
      #   @return [OpenPort, nil]
      belongs_to :open_port, optional: true

      #
      # Converts the service credential to a String.
      #
      # @return [String]
      #   The service credential string.
      #
      def to_s
        if self.open_port then "#{super} (#{self.open_port})"
        else                   super
        end
      end

    end
  end
end
