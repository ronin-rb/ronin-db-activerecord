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
require 'ronin/db/model/has_unique_name'
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents an Company.
    #
    class Organization < ActiveRecord::Base

      include Model
      include Model::HasUniqueName
      include Model::Importable

      # @!attribute [rw] id
      #   Primary key of the organization
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The type for the organization.
      #
      #   @return [String, nil]
      #
      #   @since 0.2.0
      enum :type, {
        department: 'department',
        company:    'company',
        government: 'government',
        military:   'military'
      }, prefix: 'is_'

      # @!attribute [r] created_at
      #   Tracks when the organization was first created
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # Looks up the organization.
      #
      # @param [String] name
      #   The organization name to query.
      #
      # @return [Organization, nil]
      #   The found organization.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Imports an organization.
      #
      # @param [String] name
      #   The organization name to import.
      #
      # @return [Organization]
      #   The imported organization.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.import(name)
        create(name: name)
      end

    end
  end
end

require 'ronin/db/note'
