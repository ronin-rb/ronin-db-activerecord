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

require_relative 'cert_organization'

module Ronin
  module DB
    #
    # Represents the issuer of a SSL/TLS certificate.
    #
    # @since 0.2.0
    #
    class CertIssuer < CertOrganization

      # @!attribute [rw] common_name
      #   The issuer's common name (`CN`).
      #
      #   @return [String, nil]
      #
      #   @note
      #     Some Equifax certs do not set the issuer's common name (CN),
      #     so {#common_name} may sometimes return `nil`.
      attribute :common_name, :string
      validates :common_name, uniqueness: {
        scope: [
          :email_address,
          :organization,
          :organizational_unit,
          :locality,
          :state,
          :country
        ]
      }

      # @!attribute [rw] certs
      #   The certificates that share this issuer information.
      #
      #   @return [Array<Cert>]
      has_many :certs, foreign_key: :issuer_id,
                       dependent:   :destroy

      #
      # Imports the certificate issuer's X509 distinguished name.
      #
      # @param [OpenSSL::X509::Name, String] name
      #   The X509 name to parse and import.
      #
      # @return [CertIssuer]
      #   The imported or pre-existing certificate issuer.
      #
      # @api private
      #
      def self.import(name)
        find_or_create_by(parse(name))
      end

    end
  end
end

require_relative 'cert'
