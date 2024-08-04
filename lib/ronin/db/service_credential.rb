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

require 'active_record'

module Ronin
  module DB
    #
    # Represents Credentials used to access a TCP/UDP {Service}.
    #
    class ServiceCredential < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the service credential.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] credential
      #
      #   @return [Credential]
      belongs_to :credential

      # @!attribute [rw] open_port
      #   The open port the credential belongs to.
      #
      #   @return [OpenPort]
      belongs_to :open_port

      #
      # Converts the service credential to a String.
      #
      # @return [String]
      #   The service credential string.
      #
      def to_s
        "#{self.credential} (#{self.open_port})"
      end

    end
  end
end

require_relative 'credential'
require_relative 'open_port'
