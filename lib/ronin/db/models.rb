# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'address'
require_relative 'arch'
require_relative 'credential'
require_relative 'email_address'
require_relative 'host_name'
require_relative 'host_name_ip_address'
require_relative 'ip_address'
require_relative 'ip_address_mac_address'
require_relative 'mac_address'
require_relative 'open_port'
require_relative 'organization'
require_relative 'organization_street_address'
require_relative 'organization_customer'
require_relative 'organization_department'
require_relative 'organization_phone_number'
require_relative 'organization_email_address'
require_relative 'organization_host_name'
require_relative 'organization_ip_address'
require_relative 'os'
require_relative 'os_guess'
require_relative 'password'
require_relative 'person'
require_relative 'personal_phone_number'
require_relative 'personal_email_address'
require_relative 'personal_street_address'
require_relative 'personal_connection'
require_relative 'port'
require_relative 'service'
require_relative 'service_credential'
require_relative 'software'
require_relative 'url_query_param_name'
require_relative 'url_query_param'
require_relative 'url_scheme'
require_relative 'url'
require_relative 'web_vuln'
require_relative 'user_name'
require_relative 'software_vendor'
require_relative 'web_credential'
require_relative 'asn'
require_relative 'http_query_param_name'
require_relative 'http_query_param'
require_relative 'http_header_name'
require_relative 'http_request_header'
require_relative 'http_response_header'
require_relative 'http_request'
require_relative 'http_response'
require_relative 'advisory'
require_relative 'vulnerability'
require_relative 'cert_name'
require_relative 'cert_issuer'
require_relative 'cert_subject'
require_relative 'cert_subject_alt_name'
require_relative 'cert'
require_relative 'dns_query'
require_relative 'dns_record'
require_relative 'note'

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
        OrganizationStreetAddress,
        OrganizationCustomer,
        OrganizationDepartment,
        OrganizationPhoneNumber,
        OrganizationEmailAddress,
        OrganizationHostName,
        OrganizationIPAddress,
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
        DNSQuery,
        DNSRecord,
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
