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

require_relative 'model'
require_relative 'model/has_unique_name'
require_relative 'model/importable'

module Ronin
  module DB
    #
    # Represents a certificate's common name (`CN`) or `subjectAltName`s.
    #
    # @since 0.2.0
    #
    class CertName < ActiveRecord::Base

      include Model
      include Model::HasUniqueName
      include Model::Importable

      # @!attribute [rw] id
      #   The primary key of the certificate name.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] created_at
      #   When the certificate name was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] certs
      #   The certificates that use this name as their common name (`CN`).
      #
      #   @return [Array<CertSubject>]
      has_many :subjects, class_name:  'CertSubject',
                          foreign_key: :common_name_id,
                          dependent:   :destroy

      # @!attribute [rw] subject_alt_names
      #   The certificates that use this name as one of their `subjectAltName`
      #   values.
      #
      #   @return [Array<CertSubjectAltName>]
      has_many :subject_alt_names, class_name:  'CertSubjectAltName',
                                   foreign_key: :name_id,
                                   dependent:   :destroy

      #
      # Looks up the certificate name.
      #
      # @param [String] name
      #   The name to search by.
      #
      # @return [CertName, nil]
      #   The found certificate name with the matching name.
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Imports the certificate name.
      #
      # @param [String] name
      #   The certificate name to import.
      #
      # @return [CertName]
      #   The newly created certificate name.
      #
      def self.import(name)
        create(name: name)
      end

      #
      # Converts the certificate name to a String.
      #
      # @return [String]
      #
      def to_s
        name
      end

    end
  end
end

require_relative 'cert_subject_alt_name'
require_relative 'cert'
