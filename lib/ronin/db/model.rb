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

module Ronin
  module DB
    #
    # Mixin for all `ronin-db-activerecord` models.
    #
    module Model
      #
      # Sets the models `table_name_prefix` to `ronin_`.
      #
      # @param [Class<ActiveRecord::Base>] model
      #   The ActiveRecord model class which is including {Model}.
      #
      # @api private
      #
      def self.included(model)
        model.table_name_prefix = 'ronin_'
      end
    end
  end
end
