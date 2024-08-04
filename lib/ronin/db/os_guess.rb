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
    # Represents a guess about what {OS} an {IPAddress} might be running.
    #
    class OSGuess < ActiveRecord::Base

      include Model

      self.table_name = 'ronin_os_guesses'

      # @!attribute [rw] id
      #   The primary-key of the OS guess.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] ip_address
      #   The IP Address the OS guess was made against.
      #
      #   @return [IPAddress]
      belongs_to :ip_address, required:   true,
                              class_name: 'IPAddress'

      # @!attribute [rw] os
      #   The guessed OS.
      #
      #   @return [OS]
      belongs_to :os, required:   true,
                      class_name: 'OS'

      # @!attribute [r] created_at
      #   Tracks when an OS guess is made against an IP Address.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require_relative 'ip_address'
require_relative 'os'
