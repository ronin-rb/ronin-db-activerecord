# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    # Represents an subject of a SSL/TLS certificate.
    #
    # @since 0.2.0
    #
    class CertSubject < CertOrganization

      # @!attribute [rw] common_name
      #   The subject's common name (`CN`).
      #
      #   @return [CertName]
      belongs_to :common_name, class_name: 'CertName',
                               required:   true
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
      #   The certificates that share this subject information.
      #
      #   @return [Array<Cert>]
      has_many :certs, foreign_key: :subject_id,
                       dependent:   :destroy

      #
      # Imports the certificate subject's X509 distinguished name.
      #
      # @param [OpenSSL::X509::Name, String] name
      #   The X509 name to parse and import.
      #
      # @return [CertSubject]
      #   The imported or pre-existing certificate subject.
      #
      # @api private
      #
      def self.import(name)
        attributes  = parse(name)
        common_name = attributes.fetch(:common_name)

        attributes[:common_name] = CertName.find_or_import(common_name)

        return find_or_create_by(attributes)
      end

    end
  end
end

require_relative 'cert_name'
require_relative 'cert'
