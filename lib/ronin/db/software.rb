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
require 'ronin/db/model/has_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a Software product.
    #
    class Software < ActiveRecord::Base

      include Model
      include Model::HasName

      # @!attribute [rw] id
      #   The primary key of the software.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] name
      #   The software's name.
      #
      #   @return [String]
      attribute :name, :string
      validates :name, presence: true

      # @!attribute [rw] version
      #   The software's Version.
      #
      #   @return [String]
      attribute :version, :string
      validates :version, presence:   true,
                          uniqueness: {scope: :name}

      # @!attribute [rw] vendor
      #   The vendor of the software
      #
      #   @return [SoftwareVendor, nil]
      belongs_to :vendor, optional:   true,
                          class_name: 'SoftwareVendor'

      # @!attribute [rw] open_ports
      #   The open ports running the software
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports

      #
      # Queries all software with the matching version.
      #
      # @param [String] version
      #   The version number to search for.
      #
      # @return [Array<Software>]
      #   The matching software.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.with_version(version)
        where(version: version)
      end

      #
      # Queries all software with the matching vendor name.
      #
      # @param [String] name
      #   The vendor name to search for.
      #
      # @return [Array<Software>]
      #   The matching software.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.with_vendor_name(name)
        joins(:vendor).where(vendor: {name: name})
      end

      #
      # Converts the software to a String.
      #
      # @return [String]
      #   The software vendor, name and version.
      #
      # @api public
      #
      def to_s
        [self.vendor, self.name, self.version].compact.join(' ')
      end

    end
  end
end

require 'ronin/db/software_vendor'
require 'ronin/db/open_port'
