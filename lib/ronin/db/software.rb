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
    # Represents a Software product.
    #
    class Software < ActiveRecord::Base

      include Model

      # Primary key
      attribute :id, :integer

      # Name
      attribute :name, :string
      validates :name, presence: true

      # Version
      attribute :version, :string
      validates :version, presence: true,
                          uniqueness: {scope: :name}

      # The vendor of the software
      belongs_to :vendor, optional: true,
                          class_name: 'SoftwareVendor'

      # The open ports running the software
      has_many :open_ports

      #
      # Converts the software to a String.
      #
      # @return [String]
      #   The software vendor, name and version.
      #
      # @api public
      #
      def to_s
        [self.vendor, self.name, self.version].compact.join(' ')
      end

    end
  end
end

require 'ronin/db/software_vendor'
require 'ronin/db/open_port'
