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

module Ronin
  module DB
    module Model
      module LastScannedAt
        #
        # @!attribute [rw] last_scanned_at
        #   Whenever the model was last scanned.
        #
        #   @return [Time, nil]
        #

        #
        # Adds the `last_scanned_at` attribute to the model.
        #
        # @param [Class<ActiveRecord::Base>] model
        #   The ActiveRecord model which is including {LastScannedAt}.
        #
        # @api private
        #
        def self.included(model)
          model.class_eval do
            attribute :last_scanned_at, :time
          end
        end
      end
    end
  end
end
