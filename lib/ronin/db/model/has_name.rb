# frozen_string_literal: true
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

module Ronin
  module DB
    module Model
      #
      # Adds a `name` property to a model.
      #
      module HasName
        #
        # @!attribute [rw] name
        #   The name attribute of the model.
        #
        #   @return [String]
        #

        #
        # Adds the `name` property and {ClassMethods} to the model.
        #
        # @param [Class] base
        #   The model.
        #
        # @api private
        #
        def self.included(base)
          base.send :include, Model, InstanceMethods
          base.send :extend, ClassMethods

          base.module_eval do
            # The name attribute of the model
            attribute :name, :string
            validates :name, presence: true
          end
        end

        #
        # Class methods that are added when {HasName} is included into a
        # model.
        #
        module ClassMethods
          #
          # Finds models with names containing a given fragment of text.
          #
          # @param [String] fragment
          #   The fragment of text to search for within the names of models.
          #
          # @return [Array<Model>]
          #   The found models.
          #
          # @example
          #   Exploit.named 'ProFTP'
          #
          # @api public
          #
          def named(fragment)
            name_column = self.arel_table[:name]

            where(name_column.matches("%#{sanitize_sql_like(fragment)}%"))
          end
        end

        #
        # Instance methods that are added when {HasName} is included into a
        # model.
        #
        module InstanceMethods
          #
          # Converts the named resource into a String.
          #
          # @return [String]
          #   The name of the resource.
          #
          # @api public
          #
          def to_s
            self.name.to_s
          end
        end
      end
    end
  end
end
