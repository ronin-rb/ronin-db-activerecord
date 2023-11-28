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
require 'ronin/db/model/importable'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a connection between two {Person}s.
    #
    # @since 0.2.0
    #
    class PersonalConnection < ActiveRecord::Base

      include Model

      # NOTE: disable STI so we can use the type column as an enum.
      self.inheritance_column = nil

      # @!attribute [rw] id
      #   The primary key of the friendship.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The type of the connection.
      #
      #   @return [String, nil]
      enum :type, {
        friend:   'friend',
        collegue: 'collegue',
        coworker: 'coworker',

        parent:  'parent',
        mother:  'mother',
        father:  'father',
        aunt:    'aunt',
        uncle:   'uncle',
        brother: 'brother',
        sister:  'sister',
        cousin:  'cousin',
        nephew:  'nephew',
        niece:   'niece',

        stepmother:  'stepmother',
        stepfather:  'stepfather',
        stepchild:   'stepchild',
        stepbrother: 'stepbrother',
        stepsister:  'stepsister',

        in_law:        'in-law',
        father_in_law: 'father-in-law',
        mother_in_law: 'mother-in-law',

        partner:    'partner',
        boyfriend:  'boyfriend',
        girlfriend: 'girlfriend',
        hushband:   'husband',
        wife:       'wife',

        ex:         'ex',
        ex_husband: 'ex-husband',
        ex_wife:    'ex-wife'
      }, prefix: 'is_'

      # @!attribute [rw] person
      #   The person who is befriending the other person.
      #
      #   @return [Person]
      belongs_to :person

      # @!attribute [rw] friend
      #   The friend of the {#person}.
      #
      #   @return [Person]
      belongs_to :other_person, class_name: 'Person'
      validates :other_person, uniqueness: {scope: [:person, :type]}

      # @!attribute [rw] created_at
      #   Tracks when the friendship was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

    end
  end
end

require 'ronin/db/person'
