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

require 'ronin/db/model'
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents Credentials used to access services or websites.
    #
    class Credential < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   Primary key of the credential.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] user_name
      #   User name of the credential.
      #
      #   @return [UserName, nil]
      belongs_to :user_name, optional: true
      validates :user_name, presence: true,
                            if: ->(cred) { cred.email_address.nil? }

      # @!attribute [rw] email_address
      #   The optional email address associated with the Credential
      #
      #   @return [EmailAddress, nil]
      belongs_to :email_address, optional: true
      validates :email_address, presence: true,
                                if: ->(cred) { cred.user_name.nil? }

      # @!attribute [rw] password
      #   Password of the credential.
      #
      #   @return [Password]
      belongs_to :password, required: true

      # @!attribute [rw] service_credentials
      #   The service credentials.
      #
      #   @return [Array<ServiceCredential>]
      has_many :service_credentials, dependent: :destroy

      # @!attribute [rw] open_ports
      #   The open ports that accept this credential pair.
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports, through: :service_credentials

      # @!attribute [rw] web_credentials
      #   The Web credentials.
      #
      #   @return [Array<WebCredential>]
      has_many :web_credentials, dependent: :destroy

      # @!attribute [rw] urls
      #   The URLs that accept this credential pair.
      #
      #   @return [Array<URL>]
      has_many :urls, through: :web_credentials

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

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
      # Searches all web credentials that are associated with an
      # email address.
      #
      # @param [String] email
      #   The email address to search for.
      #
      # @return [Array<WebCredential>]
      #   The web credentials associated with the email address.
      #
      # @raise [ArgumentError]
      #   The given email address was not a valid email address.
      #
      # @api public
      #
      def self.with_email_address(email)
        unless email.include?('@')
          raise(ArgumentError,"invalid email address #{email.inspect}")
        end

        user, domain = email.split('@',2)

        return joins(email_address: [:user_name, :host_name]).where(
          email_address: {
            ronin_user_names: {name: user},
            ronin_host_names: {name: domain}
          }
        )
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
        joins(:password).where(password: {plain_text: password})
      end

      #
      # Looks up the given credential.
      #
      # @param [String] cred
      #   The credential String
      #   (ex: `user:password` or `user@example.com:password`).
      #
      # @return [Credential, nil]
      #   The found credential.
      #
      def self.lookup(cred)
        unless cred.include?(':')
          raise(ArgumentError,"credential must be of the form user:password or email:password: #{cred.inspect}")
        end

        user_or_email, password = cred.split(':',2)

        query = if user_or_email.include?('@')
                  with_email_address(user_or_email)
                else
                  for_user(user_or_email)
                end
        query.with_password(password)
        return query.first
      end

      #
      # Imports the given credential.
      #
      # @param [String] cred
      #   The credential String
      #   (ex: `user:password` or `user@example.com:password`).
      #
      # @return [Credential]
      #   The imported credential.
      #
      def self.import(cred)
        unless cred.include?(':')
          raise(ArgumentError,"credential must be of the form user:password or email:password: #{cred.inspect}")
        end

        user_or_email, password = cred.split(':',2)

        if user_or_email.include?('@')
          create(
            email_address: EmailAddress.find_or_import(user_or_email),
            password:      Password.find_or_import(password)
          )
        else
          create(
            user_name: UserName.find_or_import(user_or_email),
            password:  Password.find_or_import(password)
          )
        end
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
      def plain_text
        self.password.plain_text if self.password
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
require 'ronin/db/service_credential'
require 'ronin/db/web_credential'
require 'ronin/db/note'
