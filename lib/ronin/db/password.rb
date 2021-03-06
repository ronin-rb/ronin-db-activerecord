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

require 'ronin/db/model'

require 'active_record'
require 'digest'

module Ronin
  module DB
    #
    # Represents a password used by {Service services} or {URL websites}.
    #
    class Password < ActiveRecord::Base

      include Model

      # Primary key of the password
      attribute :id, :integer

      # The clear-text of the password
      attribute :clear_text, :string # length:   256,
      validates :clear_text, presence: true, uniqueness: true

      # The credentials which use the password
      has_many :credentials, dependent: :destroy

      # The user names which use the password
      has_many :user_names, through: :credentials

      #
      # Parses a password.
      #
      # @param [#to_s] password
      #   The password to parse.
      #
      # @return [Password]
      #   The parsed password.
      #
      # @api public
      #
      def self.parse(password)
        find_or_initialize_by(clear_text: password.to_s)
      end

      #
      # Hashes the password.
      #
      # @param [Symbol, String] algorithm
      #   The digest algorithm to use.
      #
      # @param [String, nil] prepend_salt
      #   The salt data to prepend to the password.
      #
      # @param [String, nil] append_salt
      #   The salt data to append to the password.
      #
      # @return [String]
      #   The hex-digest of the hashed password.
      #
      # @raise [ArgumentError]
      #   Unknown Digest algorithm.
      #
      # @example
      #   pass = Password.new(clear_text: 'secret')
      #   
      #   pass.digest(:sha1)
      #   # => "e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4"
      #   
      #   pass.digest(:sha1, prepend_salt: "A\x90\x00")
      #   # => "e2817656a48c49f24839ccf9295b389d8f985904"
      #   
      #   pass.digest(:sha1, append_salt: "BBBB")
      #   # => "aa6ca21e446d425fc044bbb26e950a788444a5b8"
      #
      # @api public
      #
      def digest(algorithm, prepend_salt: nil, append_salt: nil)
        digest_class = begin
                         Digest.const_get(algorithm.upcase)
                       rescue LoadError
                         raise(ArgumentError,"Unknown Digest algorithm #{algorithm}")
                       end

        hash = digest_class.new
        hash << prepend_salt.to_s if prepend_salt
        hash << self.clear_text
        hash << append_salt.to_s if append_salt

        return hash.hexdigest
      end

      #
      # The number of credentials which use this password.
      #
      # @return [Integer]
      #   The number of credentials that use the password.
      #
      # @api public
      #
      def count
        self.credentials.count
      end

      #
      # Converts the password into a String.
      #
      # @return [String]
      #   The clear-text of the password.
      #
      # @api public
      #
      def to_s
        self.clear_text
      end

    end
  end
end
