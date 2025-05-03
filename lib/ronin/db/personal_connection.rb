# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require_relative 'model/importable'

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

      # @!attribute [rw] id
      #   The primary key of the friendship.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] type
      #   The type of the connection.
      #
      #   @return [String, nil]
      attribute :type, :string
      validates :type, allow_nil: true,
                       inclusion: {
                         in: %w[
                           friend
                           collegue
                           coworker

                           parent
                           mother
                           father
                           aunt
                           uncle
                           brother
                           sister
                           cousin
                           nephew
                           niece

                           stepmother
                           stepfather
                           stepchild
                           stepbrother
                           stepsister

                           in-law
                           father-in-law
                           mother-in-law

                           partner
                           boyfriend
                           girlfriend
                           husband
                           wife

                           ex
                           ex-husband
                           ex-wife
                         ]
                       }

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

      #
      # Determines if the personal connection type is 'friend'.
      #
      # @return [Boolean]
      #
      def is_friend?
        self.type == 'friend'
      end

      #
      # Determines if the personal connection type is 'collegue'.
      #
      # @return [Boolean]
      #
      def is_collegue?
        self.type == 'collegue'
      end

      #
      # Determines if the personal connection type is 'coworker'.
      #
      # @return [Boolean]
      #
      def is_coworker?
        self.type == 'coworker'
      end

      #
      # Determines if the personal connection type is 'parent'.
      #
      # @return [Boolean]
      #
      def is_parent?
        self.type == 'parent'
      end

      #
      # Determines if the personal connection type is 'mother'.
      #
      # @return [Boolean]
      #
      def is_mother?
        self.type == 'mother'
      end

      #
      # Determines if the personal connection type is 'father'.
      #
      # @return [Boolean]
      #
      def is_father?
        self.type == 'father'
      end

      #
      # Determines if the personal connection type is 'aunt'.
      #
      # @return [Boolean]
      #
      def is_aunt?
        self.type == 'aunt'
      end

      #
      # Determines if the personal connection type is 'uncle'.
      #
      # @return [Boolean]
      #
      def is_uncle?
        self.type == 'uncle'
      end

      #
      # Determines if the personal connection type is 'brother'.
      #
      # @return [Boolean]
      #
      def is_brother?
        self.type == 'brother'
      end

      #
      # Determines if the personal connection type is 'sister'.
      #
      # @return [Boolean]
      #
      def is_sister?
        self.type == 'sister'
      end

      #
      # Determines if the personal connection type is 'cousin'.
      #
      # @return [Boolean]
      #
      def is_cousin?
        self.type == 'cousin'
      end

      #
      # Determines if the personal connection type is 'nephew'.
      #
      # @return [Boolean]
      #
      def is_nephew?
        self.type == 'nephew'
      end

      #
      # Determines if the personal connection type is 'niece'.
      #
      # @return [Boolean]
      #
      def is_niece?
        self.type == 'niece'
      end

      #
      # Determines if the personal connection type is 'stepmother'.
      #
      # @return [Boolean]
      #
      def is_stepmother?
        self.type == 'stepmother'
      end

      #
      # Determines if the personal connection type is 'stepfather'.
      #
      # @return [Boolean]
      #
      def is_stepfather?
        self.type == 'stepfather'
      end

      #
      # Determines if the personal connection type is 'stepchild'.
      #
      # @return [Boolean]
      #
      def is_stepchild?
        self.type == 'stepchild'
      end

      #
      # Determines if the personal connection type is 'stepbrother'.
      #
      # @return [Boolean]
      #
      def is_stepbrother?
        self.type == 'stepbrother'
      end

      #
      # Determines if the personal connection type is 'stepsister'.
      #
      # @return [Boolean]
      #
      def is_stepsister?
        self.type == 'stepsister'
      end

      #
      # Determines if the personal connection type is 'in-law'.
      #
      # @return [Boolean]
      #
      def is_in_law?
        self.type == 'in-law'
      end

      #
      # Determines if the personal connection type is 'father-in-law'.
      #
      # @return [Boolean]
      #
      def is_father_in_law?
        self.type == 'father-in-law'
      end

      #
      # Determines if the personal connection type is 'mother-in-law'.
      #
      # @return [Boolean]
      #
      def is_mother_in_law?
        self.type == 'mother-in-law'
      end

      #
      # Determines if the personal connection type is 'partner'.
      #
      # @return [Boolean]
      #
      def is_partner?
        self.type == 'partner'
      end

      #
      # Determines if the personal connection type is 'boyfriend'.
      #
      # @return [Boolean]
      #
      def is_boyfriend?
        self.type == 'boyfriend'
      end

      #
      # Determines if the personal connection type is 'girlfriend'.
      #
      # @return [Boolean]
      #
      def is_girlfriend?
        self.type == 'girlfriend'
      end

      #
      # Determines if the personal connection type is 'husband'.
      #
      # @return [Boolean]
      #
      def is_husband?
        self.type == 'husband'
      end

      #
      # Determines if the personal connection type is 'wife'.
      #
      # @return [Boolean]
      #
      def is_wife?
        self.type == 'wife'
      end

      #
      # Determines if the personal connection type is 'ex'.
      #
      # @return [Boolean]
      #
      def is_ex?
        self.type == 'ex'
      end

      #
      # Determines if the personal connection type is 'ex-husband'.
      #
      # @return [Boolean]
      #
      def is_ex_husband?
        self.type == 'ex-husband'
      end

      #
      # Determines if the personal connection type is 'ex-wife'.
      #
      # @return [Boolean]
      #
      def is_ex_wife?
        self.type == 'ex-wife'
      end

    end
  end
end

require_relative 'person'
