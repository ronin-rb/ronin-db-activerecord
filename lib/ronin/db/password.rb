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
require_relative 'model/importable'

require 'active_record'
require 'digest'

module Ronin
  module DB
    #
    # Represents a password used by {Service services} or {URL websites}.
    #
    class Password < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   The primary key of the password.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] plain_text
      #   The clear-text of the password.
      #
      #   @return [String]
      attribute :plain_text, :string # length:   256,
      validates :plain_text, presence: true, uniqueness: true

      # @!attribute [rw] credentials
      #   The credentials which use the password.
      #
      #   @return [Array<Credential>]
      has_many :credentials, dependent: :destroy

      # @!attribute [rw] user_names
      #   The user names which use the password.
      #
      #   @return [Array<UserName>]
      has_many :user_names, through: :credentials

      # @!attribute [rw] email_addresses
      #   The email addresses which use the password.
      #
      #   @return [Array<EmailAddress>]
      #
      #   @since 0.2.0
      has_many :email_addresses, through: :credentials

      # @!attribute [rw] service_credentials
      #   The service credentials that use the password.
      #
      #   @return [Array<ServiceCredential>]
      #
      #   @since 0.2.0
      has_many :service_credentials, through: :credentials

      # @!attribute [rw] web_credentials
      #   Any web credentials that use the password.
      #
      #   @return [Array<WebCredential>]
      #
      #   @since 0.2.0
      has_many :web_credentials, through: :credentials

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # Searches for all passwords used by a specific user.
      #
      # @param [String] name
      #   The name of the user.
      #
      # @return [Array<Password>]
      #   The passwords for the user.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.for_user(name)
        joins(credentials: :user_name).where(credentials: {ronin_user_names: {name: name}})
      end

      #
      # Searches all passwords that are associated with an email address.
      #
      # @param [String] email
      #   The email address to search for.
      #
      # @return [Array<Password>]
      #   The passwords associated with the email address.
      #
      # @raise [ArgumentError]
      #   The given email address was not a valid email address.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.with_email_address(email)
        unless email.include?('@')
          raise(ArgumentError,"invalid email address #{email.inspect}")
        end

        user, domain = email.split('@',2)

        return joins(credentials: {email_address: [:user_name, :host_name]}).where(
          credentials: {
            email_address: {
              ronin_user_names: {name: user},
              ronin_host_names: {name: domain}
            }
          }
        )
      end

      #
      # Looks up the password.
      #
      # @param [#to_s] password
      #   The password to lookup.
      #
      # @return [Password, nil]
      #   The found password.
      #
      # @api public
      #
      def self.lookup(password)
        find_by(plain_text: password.to_s)
      end

      #
      # Parses a password.
      #
      # @param [#to_s] password
      #   The password to import.
      #
      # @return [Password]
      #   The imported password.
      #
      # @api public
      #
      def self.import(password)
        create(plain_text: password.to_s)
      end

      #
      # Hashes the password.
      #
      # @param [Symbol, String] algorithm
      #   The digest algorithm to use.
      #
      # @param [String, nil] prepend_salt
      #   The salt data to prepend to the password.
      #
      # @param [String, nil] append_salt
      #   The salt data to append to the password.
      #
      # @return [String]
      #   The hex-digest of the hashed password.
      #
      # @raise [ArgumentError]
      #   Unknown Digest algorithm.
      #
      # @example
      #   pass = Password.new(plain_text: 'secret')
      #
      #   pass.digest(:sha1)
      #   # => "e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4"
      #
      #   pass.digest(:sha1, prepend_salt: "A\x90\x00")
      #   # => "e2817656a48c49f24839ccf9295b389d8f985904"
      #
      #   pass.digest(:sha1, append_salt: "BBBB")
      #   # => "aa6ca21e446d425fc044bbb26e950a788444a5b8"
      #
      # @api public
      #
      def digest(algorithm, prepend_salt: nil, append_salt: nil)
        digest_class = begin
                         Digest.const_get(algorithm.upcase)
                       rescue LoadError
                         raise(ArgumentError,"Unknown Digest algorithm #{algorithm}")
                       end

        hash = digest_class.new
        hash << prepend_salt.to_s if prepend_salt
        hash << self.plain_text
        hash << append_salt.to_s if append_salt

        return hash.hexdigest
      end

      #
      # The number of credentials which use this password.
      #
      # @return [Integer]
      #   The number of credentials that use the password.
      #
      # @api public
      #
      def count
        self.credentials.count
      end

      #
      # Converts the password into a String.
      #
      # @return [String]
      #   The clear-text of the password.
      #
      # @api public
      #
      def to_s
        self.plain_text
      end

    end
  end
end

require_relative 'credential'
require_relative 'note'
