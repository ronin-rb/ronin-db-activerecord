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
require 'ronin/db/model/has_unique_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a user name and their associated {Credential credentials}
    # or {EmailAddress email addresses}.
    #
    class UserName < ActiveRecord::Base

      include Model
      include Model::HasUniqueName

      self.table_name = 'ronin_user_names'

      # The primary key of the user name
      attribute :id, :integer

      # Tracks when the user-name was created.
      attribute :created_at, :time

      # Any credentials belonging to the user
      has_many :credentials, dependent: :destroy

      # Email addresses of the user
      has_many :email_addresses, dependent: :destroy

    end
  end
end

require 'ronin/db/credential'
require 'ronin/db/email_address'
