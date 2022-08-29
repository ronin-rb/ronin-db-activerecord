#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module DB
    #
    # Represents an Operating System and pre-defines other common ones
    # ({linux}, {freebsd}, {openbsd}, {netbsd}, {macos}, and {windows}.
    #
    class OS < ActiveRecord::Base

      include Model
      include Model::HasName

      self.table_name = 'ronin_oses'

      # @!attribute [rw] id
      #   The primary key of the OS.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] flavor
      #   The flavor of the OS (Linux, BSD).
      #
      #   @return [:linux, :bsd]
      enum :flavor, {linux: 'Linux', bsd: 'BSD'}

      # @!attribute [rw] version
      #   The version of the Operating System.
      #
      #   @return [String]
      attribute :version, :string
      validates :version, presence: true,
                          uniqueness: {scope: :name}

      # @!attribute [rw] os_guesses
      #   Any OS guesses for the Operating System.
      #
      #   @return [Array<OSGuess>]
      has_many :os_guesses, dependent: :destroy,
                            class_name: 'OSGuess'

      # @!attribute [rw] ip_addresses
      #   Any IP Addresses that might be running the Operating System
      #
      #   @return [Array<IPAddress>]
      has_many :ip_addresses, through:    :os_guesses,
                              class_name: 'IPAddress'

      #
      # The Linux OS
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.linux(version)
        find_or_create_by(name: 'Linux', flavor: :linux, version: version)
      end

      #
      # The FreeBSD OS
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.freebsd(version)
        find_or_create_by(name: 'FreeBSD', flavor: :bsd, version: version)
      end

      #
      # The OpenBSD OS
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.openbsd(version)
        find_or_create_by(name: 'OpenBSD', flavor: :bsd, version: version)
      end

      #
      # The NetBSD OS
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.netbsd(version)
        find_or_create_by(name: 'NetBSD', flavor: :bsd, version: version)
      end

      #
      # The macOS OS.
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.macos(version)
        find_or_create_by(name: 'macOS', flavor: :bsd, version: version)
      end

      #
      # The Windows OS
      #
      # @param [String] version
      #   Optional version of the OS.
      #
      # @return [OS]
      #
      def self.windows(version)
        find_or_create_by(name: 'Windows', version: version)
      end

      #
      # The IP Address that was most recently guessed to be using the
      # Operating System.
      #
      # @return [IPAddress]
      #   The IP Address most recently guessed to be using the
      #   Operating System.
      #
      # @api public
      #
      def recent_ip_address
        relation = self.os_guesses.order('created_at DESC').first

        if relation
          return relation.ip_address
        end
      end

      #
      # Converts the Operating System to a String.
      #
      # @return [String]
      #   The OS name and version.
      #
      # @example
      #   os = OS.new(name: 'Linux', version: '2.6.11')
      #   os.to_s
      #   # => "Linux 2.6.11"
      #
      # @api public
      #
      def to_s
        "#{self.name} #{self.version}"
      end

    end
  end
end

require 'ronin/db/os_guess'
require 'ronin/db/ip_address'
