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
    # Represents an email address associated with a {Person}.
    #
    # @since 0.2.0
    #
    class PersonalEmailAddress < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   Primary key of the personal email address.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] person
      #   The perons.
      #
      #   @return [Person]
      belongs_to :person

      # @!attribute [rw] email_address
      #   The email address associated with the person.
      #
      #   @return [EmailAddress]
      belongs_to :email_address
      validates :email_address, uniqueness: {scope: :person_id}

      # @!attribute [r] created_at
      #   Tracks when the personal email address was first created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require 'ronin/db/person'
require 'ronin/db/email_address'
