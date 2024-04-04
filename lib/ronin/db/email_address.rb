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
require 'uri/mailto'

module Ronin
  module DB
    #
    # Represents email addresses and their associated {UserName user names} and
    # {HostName host names}.
    #
    class EmailAddress < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   The primary key of the email address.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] address
      #   The raw string of the email address.
      #
      #   @return [String]
      attribute :address, :string
      validates :address, presence: true,
                          uniqueness: true,
                          length: {maximum: 320},
                          format: {
                            with: URI::MailTo::EMAIL_REGEXP,
                            message: 'Must be a valid email address'
                          }

      # @!attribute [rw] user_name
      #   The user-name component of the email address.
      #
      #   @return [UserName]
      belongs_to :user_name, required: true
      validates :user_name, uniqueness: {scope: [:host_name_id]}

      # @!attribute [rw] host_name
      #   The host-name component of the email address.
      #
      #   @return [HostName]
      belongs_to :host_name, required: true

      # @!attribute [rw] ip_addresses
      #   Any IP addresses associated with the host name.
      #
      #   @return [Array<IPAddress>]
      has_many :ip_addresses, through:    :host_name,
                              class_name: 'IPAddress'

      # @!attribute [rw] credentials
      #   Any web credentials that are associated with the email address.
      #
      #   @return [Array<Credential>]
      has_many :credentials, dependent: :destroy

      # @!attribute [rw] passwords
      #   Any passwords used with the email address.
      #
      #   @return [Array<EmailAddress>]
      #
      #   @since 0.2.0
      has_many :passwords, through: :credentials

      # @!attribute [rw] service_credentials
      #   The service credentials that use the email address.
      #
      #   @return [Array<ServiceCredential>]
      #
      #   @since 0.2.0
      has_many :service_credentials, through: :credentials

      # @!attribute [rw] web_credentials
      #   Any web credentials that use the email address.
      #
      #   @return [Array<WebCredential>]
      #
      #   @since 0.2.0
      has_many :web_credentials, through: :credentials

      # @!attribute [rw] created_at
      #   Tracks when the email address was created at.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] personal_email_addresses
      #   The association between people and the email address.
      #
      #   @return [Array<PersonalEmailAddress>]
      #
      #   @since 0.2.0
      has_many :personal_email_addresses, dependent: :destroy

      # @!attribute [rw] people
      #   The people that use the email address.
      #
      #   @return [Array<Person>]
      #
      #   @since 0.2.0
      has_many :people, through: :personal_email_addresses

      # @!attribute [rw] organization_email_address
      #   The association of the organization that use the email address.
      #
      #   @return [OrganizationEmailAddress, nil]
      #
      #   @since 0.2.0
      has_one :organization_email_address, dependent: :destroy

      # @!attribute [rw] organization_department
      #   The organization department that uses the email address.
      #
      #   @return [OrganizationDepartment, nil]
      #
      #   @since 0.2.0
      has_one :organization_department, dependent: :nullify

      # @!attribute [rw] organization_members
      #   The organization member that uses the email address.
      #
      #   @return [OrganizationMember, nil]
      #
      #   @since 0.2.0
      has_one :organization_member, dependent: :nullify

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes, dependent: :destroy

      #
      # Searches for email addresses associated with the given host name(s).
      #
      # @param [Array<String>, String] name
      #   The host name(s) to search for.
      #
      # @return [Array<EmailAddress>]
      #   The matching email addresses.
      #
      # @api public
      #
      def self.with_host_name(name)
        joins(:host_name).where(host_name: {name: name})
      end

      #
      # Searches for email addresses associated with the given IP address(es).
      #
      # @param [Array<String>, String] ip
      #   The IP address(es) to search for.
      #
      # @return [Array<EmailAddress>]
      #   The matching email addresses.
      #
      # @api public
      #
      def self.with_ip_address(ip)
        joins(:ip_addresses).where(ip_addresses: {address: ip})
      end

      #
      # Searches for email addresses associated with the given user name(s).
      #
      # @param [Array<String>, String] name
      #   The user name(s) to search for.
      #
      # @return [Array<EmailAddress>]
      #   The matching email addresses.
      #
      # @api public
      #
      def self.with_user_name(name)
        joins(:user_name).where(user_name: {name: name})
      end

      #
      # Queries all email addresses that are associated with the password.
      #
      # @param [String] password
      #   The plain-text password.
      #
      # @return [Array<EmailAddress>]
      #   The email addresses that are associated with the password.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.with_password(password)
        joins(credentials: :password).where(
          credentials: {
            ronin_passwords: {
              plain_text: password
            }
          }
        )
      end

      #
      # Queries all email addresses that are associated with the person.
      #
      # @param [String] full_name
      #   The person's full name to search for.
      #
      # @return [Array<EmailAddress>]
      #   The email addresses that are associated with the person.
      #
      # @api public
      #
      # @since 0.2.0
      #
      def self.for_person(full_name)
        joins(:people).where(people: {full_name: full_name})
      end

      #
      # Looks up the email address.
      #
      # @param [String] email
      #   The raw email address string.
      #
      # @return [EmailAddress, nil]
      #   The found email address.
      #
      def self.lookup(email)
        find_by(address: email)
      end

      #
      # Imports an email address.
      #
      # @param [String] email
      #   The email address to parse.
      #
      # @return [EmailAddress]
      #   A new or previously saved email address resource.
      #
      # @raise [ArgumentError]
      #   The email address did not have a user name or a host name.
      #
      # @api public
      #
      def self.import(email)
        unless email =~ URI::MailTo::EMAIL_REGEXP
          raise(ArgumentError,"invalid email address: #{email.inspect}")
        end

        normalized_email = email.downcase
        user, host       = normalized_email.split('@',2)

        if user.empty?
          raise(ArgumentError,"email address #{email.inspect} must have a user name")
        end

        if host.empty?
          raise(ArgumentError,"email address #{email.inspect} must have a host name")
        end

        return create(
          address:   normalized_email,
          user_name: UserName.find_or_import(user),
          host_name: HostName.find_or_import(host)
        )
      end

      #
      # The user of the email address.
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
      # The host of the email address.
      #
      # @return [String]
      #   The host name.
      #
      # @api public
      #
      def host
        self.host_name.name if self.host_name
      end

      #
      # Converts the email address into a String.
      #
      # @return [String]
      #   The raw email address.
      #
      # @api public
      #
      def to_s
        "#{self.user_name}@#{self.host_name}"
      end

    end
  end
end

require 'ronin/db/user_name'
require 'ronin/db/host_name'
require 'ronin/db/personal_email_address'
require 'ronin/db/organization_department'
require 'ronin/db/organization_email_address'
require 'ronin/db/organization_member'
require 'ronin/db/note'
