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
    # Represents a guess about what {OS} an {IPAddress} might be running.
    #
    class OSGuess < ActiveRecord::Base

      include Model

      self.table_name = 'ronin_os_guesses'

      # The primary-key of the OS guess.
      attribute :id, :integer

      # The IP Address the OS guess was made against.
      belongs_to :ip_address, required:   true,
                              class_name: 'IPAddress'

      # The guessed OS.
      belongs_to :os, required:   true,
                      class_name: 'OS'

      # Tracks when an OS guess is made against an IP Address.
      attribute :created_at, :time

    end
  end
end

require 'ronin/db/ip_address'
require 'ronin/db/os'
