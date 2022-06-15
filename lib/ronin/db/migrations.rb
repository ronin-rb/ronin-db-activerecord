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

require 'ronin/db/schema_migration'

require 'active_record'
require 'active_record/migration'

module Ronin
  module DB
    module Migrations
      #
      # The current migration version of the database.
      #
      # @return [Integer]
      #
      def self.current_version
        context.current_version
      end

      #
      # Determines if the database needs migrating up.
      #
      # @return [Boolean]
      #
      def self.needs_migration?
        context.needs_migration?
      end

      #
      # Migrates the database to the target version.
      #
      # @param [Integer, nil] target_version
      #   The desired target version.
      #
      # @api semipublic
      #
      def self.migrate(target_version=nil)
        context.migrate(target_version)
      end

      # 
      # Explicitly migrates up the database to the target version.
      #
      # @param [Integer, nil] target_version
      #   The desired target version.
      #
      # @api semipublic
      #
      def self.up(target_version=nil,&block)
        context.up(target_version,&block)
      end

      # 
      # Explicitly migrates down the database to the target version.
      # 
      # @param [Integer, nil] target_version
      #   The desired target version.
      #
      # @api semipublic
      #
      def self.down(target_version=nil,&block)
        context.down(target_version,&block)
      end

      # 
      # Rollbacks the last number of migrations.
      #
      # @param [Integer] steps
      #   The number of migrations to rollback.
      #
      # @api semipublic
      #
      def self.rollback(steps=1)
        context.rollback(steps)
      end

      # 
      # Applies the next number of migrations.
      #
      # @param [Integer] steps
      #   The number of migrations to rollback.
      #
      # @api semipublic
      #
      def self.foreward(steps=1)
        context.foreward(steps)
      end

      private

      # Path to the `db/migrate/` directory in `ronin-db-activerecord`.
      DIR = File.expand_path('../../../db/migrate',__dir__)

      #
      # Extensions `ActiveRecord::MigrationContext` to load our migrations from
      # the `db/migrate/` directory and update our
      # `ronin_schema_migration` table.
      #
      # @api private
      #
      class MigrationContext < ActiveRecord::MigrationContext

        def initialize
          super([Ronin::DB::Migrations::DIR],Ronin::DB::SchemaMigration)
        end

      end

      #
      # The migration context.
      #
      # @return [MigrationContext]
      #
      def self.context
        @migrations ||= MigrationContext.new
      end
    end
  end
end
