# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/db/organization_customer'
require 'ronin/db/organization_department'
require 'ronin/db/organization_phone_number'
require 'ronin/db/os'
require 'ronin/db/os_guess'
require 'ronin/db/password'
require 'ronin/db/person'
require 'ronin/db/personal_phone_number'
require 'ronin/db/personal_email_address'
require 'ronin/db/personal_street_address'
require 'ronin/db/personal_connection'
require 'ronin/db/port'
require 'ronin/db/service'
require 'ronin/db/service_credential'
require 'ronin/db/software'
require 'ronin/db/url_query_param_name'
require 'ronin/db/url_query_param'
require 'ronin/db/url_scheme'
require 'ronin/db/url'
require 'ronin/db/web_vuln'
require 'ronin/db/user_name'
require 'ronin/db/software_vendor'
require 'ronin/db/web_credential'
require 'ronin/db/asn'
require 'ronin/db/http_query_param_name'
require 'ronin/db/http_query_param'
require 'ronin/db/http_header_name'
require 'ronin/db/http_request_header'
require 'ronin/db/http_response_header'
require 'ronin/db/http_request'
require 'ronin/db/http_response'
require 'ronin/db/advisory'
require 'ronin/db/vulnerability'
require 'ronin/db/cert_name'
require 'ronin/db/cert_issuer'
require 'ronin/db/cert_subject'
require 'ronin/db/cert_subject_alt_name'
require 'ronin/db/cert'
require 'ronin/db/note'

module Ronin
  module DB
    #
    # Manages all models defined in `ronin-db-activerecord`.
    #
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
        OrganizationCustomer,
        OrganizationDepartment,
        OrganizationPhoneNumber,
        Password,
        Person,
        PersonalPhoneNumber,
        PersonalEmailAddress,
        PersonalStreetAddress,
        PersonalConnection,
        Port,
        Service,
        ServiceCredential,
        Software,
        URLQueryParamName,
        URLQueryParam,
        URLScheme,
        URL,
        WebVuln,
        UserName,
        SoftwareVendor,
        WebCredential,
        ASN,
        HTTPQueryParamName,
        HTTPQueryParam,
        HTTPHeaderName,
        HTTPRequestHeader,
        HTTPResponseHeader,
        HTTPRequest,
        HTTPResponse,
        Advisory,
        Vulnerability,
        CertName,
        CertIssuer,
        CertSubject,
        CertSubjectAltName,
        Cert,
        Note
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
