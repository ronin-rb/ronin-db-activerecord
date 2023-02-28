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

module Ronin
  module DB
    module Model
      #
      # Allows a model to import records from raw values.
      #
      module Importable
        #
        # Adds {ClassMethods} to the model including {Importable}.
        #
        # @param [Class] model
        #   The model including {Importable}.
        #
        # @api private
        #
        def self.included(model)
          model.extend ClassMethods
        end

        #
        # Class-methods which will be added to the model.
        #
        module ClassMethods
          #
          # Looks up a record with the given value.
          #
          # @param [Object] value
          #   The raw value to use for the query.
          #
          # @return [ActiveRecord::Base, nil]
          #   The found record.
          #
          def lookup(value)
            raise(NotImplementedError,"#{self} did not define a self.lookup method")
          end

          #
          # Imports a record from the given value.
          #
          # @param [Object] value
          #   The raw value that represents the record.
          #
          # @return [ActiveRecord::Base]
          #   The imported record.
          #
          # @abstract
          #
          def import(value)
            raise(NotImplementedError,"#{self} did not define a self.import method")
          end

          #
          # Finds or imports a new record.
          #
          # @param [Object] value
          #   The raw value that represents the record.
          #
          # @return [ActiveRecord::Base]
          #   The found or created record.
          #
          def find_or_import(value)
            lookup(value) || import(value)
          end
        end
      end
    end
  end
end
