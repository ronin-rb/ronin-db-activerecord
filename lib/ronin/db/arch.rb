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
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a Computer Architecture and predefines many other common
    # architectures ({x86}, {x86_64}, {ppc}, {ppc64}, {mips}, {mips_le},
    # {mips_be}, {arm}, {arm_le}, and {arm_be}).
    #
    class Arch < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      # @!attribute [rw] id
      #   The primary key of the arch.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] endian
      #   Endianness of the architecture.
      #
      #   @return [:little, :big]
      enum :endian, {little: 'little', big: 'big'}
      validates :endian, presence: true

      # @!attribute [rw] word_size
      #   Address length of the architecture.
      #
      #   @return [Integer]
      attribute :word_size, :integer
      validates :word_size, presence: true,
                            inclusion: {in: [4, 8]}

      #
      # The x86 Architecture
      #
      # @return [Arch]
      #
      def self.x86
        find_or_create_by(name: 'x86')
      end

      #
      # The i686 Architecture
      #
      # @return [Arch]
      #
      def self.i686
        find_or_create_by(name: 'i686')
      end

      #
      # The x86_64 Architecture
      #
      # @return [Arch]
      #
      def self.x86_64
        find_or_create_by(name: 'x86-64')
      end

      #
      # The 32-bit PowerPC Architecture
      #
      # @return [Arch]
      #
      def self.ppc
        find_or_create_by(name: 'PPC')
      end

      #
      # The 64-bit PowerPC Architecture
      #
      # @return [Arch]
      #
      def self.ppc64
        find_or_create_by(name: 'PPC64')
      end

      #
      # The MIPS Architecture
      #
      # @return [Arch]
      #
      def self.mips
        find_or_create_by(name: 'MIPS')
      end

      #
      # The MIPS (little endian) Architecture
      #
      # @return [Arch]
      #
      def self.mips_le
        find_or_create_by(name: 'MIPS (Little-Endian)')
      end

      #
      # The MIPS (big endian) Architecture
      #
      # @return [Arch]
      #
      def self.mips_be
        find_or_create_by(name: 'MIPS (Big-Endian)')
      end

      #
      # The ARM Architecture
      #
      # @return [Arch]
      #
      def self.arm
        find_or_create_by(name: 'ARM')
      end

      #
      # The ARM (little endian) Architecture
      #
      # @return [Arch]
      #
      def self.arm_le
        find_or_create_by(name: 'ARM (Little-Endian)')
      end

      #
      # The ARM (big endian) Architecture
      #
      # @return [Arch]
      #
      def self.arm_be
        find_or_create_by(name: 'ARM (Big-Endian)')
      end

    end
  end
end
