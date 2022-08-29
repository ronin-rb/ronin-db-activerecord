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

require 'ronin/db/credential'

module Ronin
  module DB
    #
    # Represents Credentials used to access websites at specified {URL}s.
    #
    class WebCredential < Credential

      # @!attribute [rw] url
      #   The URL the credential can be used with.
      #
      #   @return [URL, nil]
      belongs_to :url, optional:   true,
                       class_name: 'URL'

      #
      # Searches all web credentials that are associated with an
      # email address.
      #
      # @param [String] email
      #   The email address to search for.
      #
      # @return [Array<WebCredential>]
      #   The web credentials associated with the email address.
      #
      # @api public
      #
      def self.with_email(email)
        unless email.include?('@')
          raise("invalid email address #{email.dump}")
        end

        user, domain = email.split('@',2)

        return joins(email_address: [:user_name, :host_name]).where(
          email_address: {
            user_name: {name: user},
            host_name: {address: domain}
          }
        )
      end

      #
      # Converts the web credential to a String.
      #
      # @return [String]
      #   The user name, clear-text password and the optional email address.
      #
      # @api public
      #
      def to_s
        if self.email_address then "#{super} (#{self.email_address})"
        else                       super
        end
      end

    end
  end
end
