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
require 'ronin/db/model/importable'
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a user name and their associated {Credential credentials}
    # or {EmailAddress email addresses}.
    #
    class UserName < ActiveRecord::Base

      include Model
      include Model::Importable
      include Model::HasUniqueName

      self.table_name = 'ronin_user_names'

      # @!attribute [rw] id
      #   The primary key of the user name.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [r] created_at
      #   Tracks when the user-name was created.
      #
      #   @return [Time]
      attribute :created_at, :time

      # @!attribute [rw] credentials
      #   Any credentials belonging to the user.
      #
      #   @return [Array<Credential>]
      has_many :credentials, dependent: :destroy

      # @!attribute [rw] email_addresses
      #   The email addresses of the user.
      #
      #   @return [Array<EmailAddress>]
      has_many :email_addresses, dependent: :destroy

      #
      # Looks up the user name.
      #
      # @param [String] name
      #   The user name to lookup.
      #
      # @return [UserName, nil]
      #   The found user name.
      #
      def self.lookup(name)
        find_by(name: name)
      end

      #
      # Imports a user name.
      #
      # @param [String] name
      #   The user name to import.
      #
      # @return [UserName]
      #   The imported user name.
      #
      def self.import(name)
        create(name: name)
      end

    end
  end
end

require 'ronin/db/credential'
require 'ronin/db/email_address'
