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

require 'ronin/db/address'
require 'ronin/db/arch'
require 'ronin/db/credential'
require 'ronin/db/email_address'
require 'ronin/db/host_name'
require 'ronin/db/host_name_ip_address'
require 'ronin/db/ip_address'
require 'ronin/db/ip_address_mac_address'
require 'ronin/db/mac_address'
require 'ronin/db/open_port'
require 'ronin/db/organization'
require 'ronin/db/os'
require 'ronin/db/os_guess'
require 'ronin/db/password'
require 'ronin/db/port'
require 'ronin/db/service'
require 'ronin/db/service_credential'
require 'ronin/db/software'
require 'ronin/db/url_query_param_name'
require 'ronin/db/url_query_param'
require 'ronin/db/url_scheme'
require 'ronin/db/url'
require 'ronin/db/user_name'
require 'ronin/db/software_vendor'
require 'ronin/db/web_credential'

module Ronin
  module DB
    module Models
      ALL = [
        Address,
        Arch,
        Credential,
        EmailAddress,
        HostName,
        HostNameIPAddress,
        IPAddress,
        IPAddressMACAddress,
        MACAddress,
        OS,
        OSGuess,
        OpenPort,
        Organization,
        Password,
        Port,
        Service,
        ServiceCredential,
        Software,
        URLQueryParamName,
        URLQueryParam,
        URLScheme,
        URL,
        UserName,
        SoftwareVendor,
        WebCredential
      ]

      #
      # Calls `.connect` on all {Ronin::DB} models.
      #
      # @api semipublic
      #
      def self.connect
        ALL.each(&:connection)
      end
    end
  end
end
