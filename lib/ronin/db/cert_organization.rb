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

require_relative 'model'

module Ronin
  module DB
    #
    # Base class for {CertIssuer} and {CertSubject}.
    #
    # @since 0.2.0
    #
    class CertOrganization < ActiveRecord::Base

      include Model

      self.abstract_class = true

      # @!attribute [rw] id
      #   The primary key of the certificate organization.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] organization
      #   The organization name (`O`).
      #
      #   @return [String]
      attribute :organization, :string
      validates :organization, presence: true

      # @!attribute [rw] organizational_unit
      #   The organizational unit (`OU`).
      #
      #   @return [String, nil]
      attribute :organizational_unit, :string

      # @!attribute [rw] locality
      #   The locality (`L`)..
      #
      #   @return [String, nil]
      attribute :locality, :string

      # @!attribute [rw] state
      #   The state (`ST`).
      #
      #   @return [String, nil]
      attribute :state, :string

      # @!attribute [rw] country
      #   The two letter country code (`C`).
      #
      #   @return [String]
      attribute :country, :string
      validates :country, presence: true,
                          length: {is: 2}

      # @!attribute [rw] created_at
      #   When the organization was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # Mapping of X509 names to Symbols.
      #
      # @api private
      X509_ATTRIBUTES = {
        'CN'           => :common_name,
        'emailAddress' => :email_address,
        'O'            => :organization,
        'OU'           => :organizational_unit,
        'L'            => :locality,
        'ST'           => :state,
        'C'            => :country
      }

      #
      # Parses an X509 Name into attributes.
      #
      # @param [OpenSSL::X509::Name, String] name
      #   The X509 name to parse.
      #
      # @return [Hash{Symbol => String}]
      #   The parsed attributes.
      #
      # @api private
      #
      def self.parse(name)
        x509_name = case name
                    when OpenSSL::X509::Name then name
                    when String
                      OpenSSL::X509::Name.parse(name)
                    else
                      raise(ArgumentError,"value must be either an OpenSSL::X509::Name or a String: #{name.inspect}")
                    end

        attributes = {}

        x509_name.to_a.each do |(oid,value,type)|
          if (key = X509_ATTRIBUTES[oid])
            attributes[key] = value.force_encoding(Encoding::UTF_8)
          end
        end

        return attributes
      end

    end
  end
end
