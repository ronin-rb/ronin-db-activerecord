#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-db-activerecord.
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

require 'active_record'

module Ronin
  module DB
    #
    # Represents Credentials used to access services or websites.
    #
    class Credential < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the credential.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] user_name
      #   User name of the credential.
      #
      #   @return [UserName]
      belongs_to :user_name, required: true

      # @!attribute [rw] email_address
      #   The optional email address associated with the Credential
      #
      #   @return [EmailAddress]
      belongs_to :email_address, optional: true

      # @!attribute [rw] password
      #   Password of the credential.
      #
      #   @return [Password]
      belongs_to :password, required: true

      #
      # Searches for all credentials for a specific user.
      #
      # @param [String] name
      #   The name of the user.
      #
      # @return [Array<Credential>]
      #   The credentials for the user.
      #
      # @api public
      #
      def self.for_user(name)
        joins(:user_name).where(user_name: {name: name})
      end

      #
      # Searches for all credentials with a common password.
      #
      # @param [String] password
      #   The password to search for.
      #
      # @return [Array<Credential>]
      #   The credentials with the common password.
      #
      # @api public
      #
      def self.with_password(password)
        joins(:password).where(password: {clear_text: password})
      end

      #
      # The user the credential belongs to.
      #
      # @return [String]
      #   The user name.
      #
      # @api public
      #
      def user
        self.user_name.name if self.user_name
      end

      #
      # The clear-text password of the credential.
      #
      # @return [String]
      #   The clear-text password.
      #
      # @api public
      #
      def clear_text
        self.password.clear_text if self.password
      end

      #
      # Converts the credentials to a String.
      #
      # @return [String]
      #   The user name and the password.
      #
      # @api public
      #
      def to_s
        "#{self.user_name}:#{self.password}"
      end

    end
  end
end

require 'ronin/db/user_name'
require 'ronin/db/email_address'
require 'ronin/db/password'
