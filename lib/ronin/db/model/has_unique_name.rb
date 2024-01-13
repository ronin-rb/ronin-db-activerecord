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

require 'ronin/db/model/has_name'

module Ronin
  module DB
    module Model
      #
      # Adds a unique `name` property to a model.
      #
      module HasUniqueName
        #
        # @!attribute [rw] name
        #   The unique name of the model.
        #
        #   @return [String]
        #

        #
        # Adds the unique `name` property and {HasName::ClassMethods} to the
        # model.
        #
        # @param [Class] base
        #   The model.
        #
        # @api semipublic
        #
        def self.included(base)
          base.send :include, Model, HasName::InstanceMethods

          base.send :extend, HasName::ClassMethods, HasUniqueName::ClassMethods

          base.module_eval do
            # The name of the model
            attribute :name, :string
            validates :name, presence: true, uniqueness: true
          end
        end

        #
        # Class methods that will be added when {HasUniqueName} is included.
        #
        module ClassMethods
          #
          # Parses a unique name.
          #
          # @param [String] name
          #   The name to parse.
          #
          # @return [Model]
          #   A new or previously saved resource.
          #
          # @api public
          #
          def parse(name)
            find_or_initialize_by(name: name.strip)
          end
        end
      end
    end
  end
end
