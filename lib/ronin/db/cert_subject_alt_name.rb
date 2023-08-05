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

require 'ronin/db/model'

require 'ipaddr'

module Ronin
  module DB
    #
    # Represents a `subjectAltName` value from a SSL/TLS certificate.
    #
    # @since 0.2.0
    #
    class CertSubjectAltName < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the certificate `subjectAltName` value.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   A `DNS:`, `IP:`, or `Email:` name.
      #
      #   @return [CertName]
      belongs_to :name, class_name: 'CertName',
                        required:   true

      # @!attribute [rw] cert
      #   The parent certificate.
      #
      #   @return [Cert]
      belongs_to :cert, required: true

      #
      # Parses a `subjectAltName` string.
      #
      # @param [String] string
      #   The `subjectAltName` string.
      #
      # @return [Array<String>]
      #   The parsed `subjectAltName`s.
      #
      # @api private
      #
      def self.parse(string)
        string.split(', ').map do |item|
          _prefix, name = item.split(':',2)

          name
        end
      end

      #
      # Converts the certificate `subjectAltName` to a String.
      #
      # @return [String]
      #
      def to_s
        name.to_s
      end

    end
  end
end

require 'ronin/db/cert_name'
require 'ronin/db/cert'
