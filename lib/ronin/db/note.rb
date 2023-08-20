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

require 'active_record'

module Ronin
  module DB
    #
    # A model for associating notes with other models.
    #
    # @since 0.2.0
    #
    class Note < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the Note.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] body
      #   The note text.
      #
      #   @return [String]
      attribute :body, :text
      validates :body, presence: true

      # @!attribute [rw] created_at
      #   Tracks when the note was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] updated_at
      #   Tracks when the note was last edited.
      #
      #   @return [Time]
      attribute :updated_at, :datetime

      # @!attribute [rw] mac_address
      #   The associated MAC address.
      #
      #   @return [MACAddress, nil]
      belongs_to :mac_address, optional:   true,
                               class_name: 'MACAddress'

      # @!attribute [rw] ip_address
      #   The associated IP address.
      #
      #   @return [IPAddress, nil]
      belongs_to :ip_address, optional:   true,
                              class_name: 'IPAddress'

      # @!attribute [rw] host_name
      #   The associated host name.
      #
      #   @return [HostName, nil]
      belongs_to :host_name, optional: true

      # @!attribute [rw] port
      #   The associated port.
      #
      #   @return [Port, nil]
      belongs_to :port, optional: true

      # @!attribute [rw] service
      #   The associated service.
      #
      #   @return [Service, nil]
      belongs_to :service, optional: true

      # @!attribute [rw] open_port
      #   The associated open port.
      #
      #   @return [OpenPort, nil]
      belongs_to :open_port, optional: true

      # @!attribute [rw] cert
      #   The associated certificate.
      #
      #   @return [Cert, nil]
      belongs_to :cert, optional: true

      # @!attribute [rw] url
      #   The associated URL.
      #
      #   @return [URL, nil]
      belongs_to :url, optional:   true,
                       class_name: 'URL'

      # @!attribute [rw] user_name
      #   The associated user name.
      #
      #   @return [UserName, nil]
      belongs_to :user_name, optional: true

      # @!attribute [rw] email_address
      #   The associated email address.
      #
      #   @return [EmailAddress, nil]
      belongs_to :email_address, optional: true

      # @!attribute [rw] password
      #   The associated password.
      #
      #   @return [Password, nil]
      belongs_to :password, optional: true

      # @!attribute [rw] credential
      #   The associated credential.
      #
      #   @return [Credential, nil]
      belongs_to :credential, optional: true

      # @!attribute [rw] advisory
      #   The associated advisory.
      #
      #   @return [Advisory, nil]
      belongs_to :advisory, optional: true

      # @!attribute [rw] phone_number
      #   The associated phone number.
      #
      #   @return [PhoneNumber, nil]
      belongs_to :phone_number, optional: true

      # @!attribute [rw] street_address
      #   The associated street address.
      #
      #   @return [StreetAddress, nil]
      belongs_to :street_address, optional: true

      # @!attribute [rw] person
      #   The associated person.
      #
      #   @return [Person, nil]
      belongs_to :person, optional: true

      validate :validate_at_least_one_belongs_to_set

      private

      #
      # Validates that at least one of the `belongs_to` associations is set.
      #
      def validate_at_least_one_belongs_to_set
        unless (mac_address || ip_address || host_name || port || service || open_port || cert || url || user_name || email_address || password || credential || advisory || phone_number || street_address || person)
          errors.add(:base, 'note must be associated with a MACAddress, IPAddress, HostName, Port, Service, OpenPort, Cert, URL, UserName, EmailAddress, Password, Credential, Advisory, PhoneNumber, StreetAddress, or Person')
        end
      end

    end
  end
end

require 'ronin/db/mac_address'
require 'ronin/db/ip_address'
require 'ronin/db/host_name'
require 'ronin/db/port'
require 'ronin/db/service'
require 'ronin/db/open_port'
require 'ronin/db/cert'
require 'ronin/db/url'
require 'ronin/db/user_name'
require 'ronin/db/email_address'
require 'ronin/db/password'
require 'ronin/db/credential'
require 'ronin/db/advisory'
require 'ronin/db/street_address'
require 'ronin/db/phone_number'
require 'ronin/db/person'
