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
require 'ronin/db/model/has_name'

require 'active_record'

module Ronin
  module DB
    #
    # Represents a department of an organization.
    #
    # @since 0.2.0
    #
    class OrganizationDepartment < ActiveRecord::Base

      include Model
      include Model::HasName

      # @!attribute [rw] organization
      #   The organization that the department belongs to.
      #
      #   @return [Organization]
      belongs_to :organization
      validates :name, uniqueness: {scope: :organization_id}

      # @!attribute [rw] street_address
      #   The optional street address of the department.
      #
      #   @return [StreetAddress, nil]
      belongs_to :street_address, optional: true

      # @!attribute [rw] phone_number
      #   The optional phone number of the department.
      #
      #   @return [PhoneNumber, nil]
      belongs_to :phone_number, optional: true

      # @!attribute [rw] email_address
      #   The optional email address of the department.
      #
      #   @return [EmailAddress, nil]
      belongs_to :email_address, optional: true

      # @!attribute [rw] parent_department
      #   The optional parent department of the subdepartment.
      #
      #   @return [OrganizationDepartment, nil]
      belongs_to :parent_department, optional:   true,
                                     class_name: 'OrganizationDepartment'

      # @!attribute [r] created_at
      #   Tracks when the organization was first created
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] subdepartments
      #   The associated subdepartments of the department.
      #
      #   @return [Array<OrganizationDepartment>]
      has_many :subdepartments, class_name:  'OrganizationDepartment',
                                foreign_key: :parent_department_id,
                                dependent:   :destroy

    end
  end
end

require 'ronin/db/organization'
require 'ronin/db/street_address'
require 'ronin/db/phone_number'
require 'ronin/db/email_address'
