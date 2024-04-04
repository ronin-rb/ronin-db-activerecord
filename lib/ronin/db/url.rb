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
require 'ronin/db/model/importable'
require 'ronin/db/model/last_scanned_at'

require 'active_record'
require 'uri/generic'
require 'uri/http'
require 'uri/https'
require 'uri/ftp'
require 'uri/query_params'

module Ronin
  module DB
    #
    # Represents parsed URLs.
    #
    class URL < ActiveRecord::Base

      include Model
      include Model::Importable
      include Model::LastScannedAt

      # Mapping of URL Schemes and URI classes
      SCHEMES = {
        'https' => ::URI::HTTPS,
        'http'  => ::URI::HTTP,
        'ftp'   => ::URI::FTP
      }

      # @!attribute [rw] id
      #   The primary key of the URL.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] scheme
      #   The scheme of the URL.
      #
      #   @return [URLScheme]
      belongs_to :scheme, required:   true,
                          class_name: 'URLScheme'

      # @!attribute [rw] host_name
      #   The host name of the URL
      #
      #   @return [HostName]
      belongs_to :host_name, required: true

      # @!attribute [rw] port
      #   The port of the URL.
      #
      #   @return [Port, nil]
      belongs_to :port, optional:   true,
                        class_name: 'Port'

      # @!attribute [rw] path
      #   The path of the URL.
      #
      #   @return [String]
      attribute :path, :string

      # @!attribute [rw] query
      #   The query string part of the URL.
      #
      #   @return [String, nil]
      attribute :query, :string

      # @!attribute [rw] fragment
      #   The fragment of the URL.
      #
      #   @return [String, nil]
      attribute :fragment, :string

      # @!attribute [r] created_at
      #   Defines the created_at timestamp
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] query_params
      #   The query params of the URL.
      #
      #   @return [Array<URLQueryParam>]
      has_many :query_params, class_name: 'URLQueryParam',
                              dependent:  :destroy

      # @!attribute [rw] web_credentials
      #   Any credentials used with the URL.
      #
      #   @return [Array<WebCredential>]
      has_many :web_credentials, dependent: :destroy

      # @!attribute [rw] credentials
      #   The credentials that will work with this URL.
      #
      #   @return [Array<Credentials>]
      has_many :credentials, through: :web_credentials

      # @!attribute [rw] vulnerabilities
      #   The vulnerabilities which reference the URL.
      #
      #   @return [Array<Vulnerability>]
      #
      #   @since 0.2.0
      has_many :vulnerabilities, dependent: :destroy

      #
      # Searches for all URLs using HTTP.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.http
        joins(:scheme).where(scheme: {name: 'http'})
      end

      #
      # Searches for all URLs using HTTPS.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.https
        joins(:scheme).where(scheme: {name: 'https'})
      end

      #
      # Searches for URLs with specific host name(s).
      #
      # @param [String, Array<String>] name
      #   The host name(s) to search for.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.with_host_name(name)
        joins(:host_name).where(host_name: {name: name})
      end

      #
      # Searches for URLs with the specific port number(s).
      #
      # @param [Integer, Array<Integer>] number
      #   The port number(s) to search for.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.with_port_number(number)
        joins(:port).where(port: {number: number})
      end

      #
      # Searches for all URLs with the exact path.
      #
      # @param [String] path
      #   The path to search for.
      #
      # @return [Array<URL>]
      #   The URL with the matching path.
      #
      # @api public
      #
      def self.with_path(path)
        where(path: path)
      end

      #
      # Searches for all URLs with the exact fragment.
      #
      # @param [String] fragment
      #   The fragment to search for.
      #
      # @return [Array<URL>]
      #   The URL with the matching fragment.
      #
      # @api public
      #
      def self.with_fragment(fragment)
        where(fragment: fragment)
      end

      #
      # Searches for all URLs sharing a common sub-directory.
      #
      # @param [String] root_dir
      #   The sub-directory to search for.
      #
      # @return [Array<URL>]
      #   The URL with the common sub-directory.
      #
      # @api public
      #
      def self.with_directory(root_dir)
        path_column = self.arel_table[:path]

        where(path: root_dir).or(where(path_column.matches("#{root_dir}/%")))
      end

      #
      # Searches for all URLs sharing a common base name.
      #
      # @param [String] basename
      #   The base name to search for.
      #
      # @return [Array<URL>]
      #   The URL with the common base name.
      #
      # @api public
      #
      def self.with_basename(basename)
        path_column = self.arel_table[:path]

        where(path_column.matches("%/#{basename}"))
      end

      #
      # Searches for all URLs with a common file-extension.
      #
      # @param [String] ext
      #   The file extension to search for.
      #
      # @return [Array<URL>]
      #   The URLs with the common file-extension.
      #
      # @api public
      #
      def self.with_file_ext(ext)
        path_column = self.arel_table[:path]

        where(path_column.matches("%.#{sanitize_sql_like(ext)}"))
      end

      #
      # Searches for URLs with the given query param name and value.
      #
      # @param [String, Array<String>] name
      #   The query param name to search for.
      #
      # @param [String, Array<String>] value
      #   The query param value to search for.
      #
      # @return [Array<URL>]
      #   The URLs with the given query param.
      #
      # @api public
      #
      def self.with_query_param(name,value)
        joins(query_params: :name).where(
          query_params: {
            ronin_url_query_param_names:  {name: name},
            value: value
          }
        )
      end

      #
      # Search for all URLs with a given query param name.
      #
      # @param [Array<String>, String] name
      #   The query param name to search for.
      #
      # @return [Array<URL>]
      #   The URLs with the given query param name.
      #
      # @api public
      #
      def self.with_query_param_name(name)
        joins(query_params: [:name]).where(
          query_params: {
            ronin_url_query_param_names: {name: name}
          }
        )
      end

      #
      # Search for all URLs with a given query param value.
      #
      # @param [Array<String>, String] value
      #   The query param value to search for.
      #
      # @return [Array<URL>]
      #   The URLs with the given query param value.
      #
      # @api public
      #
      def self.with_query_param_value(value)
        joins(:query_params).where(query_params: {value: value})
      end

      #
      # Searches for a URL.
      #
      # @param [URI::HTTP, String] url
      #   The URL to search for.
      #
      # @return [URL, nil]
      #   The matching URL.
      #
      # @api public
      #
      def self.lookup(url)
        uri = URI(url)

        # create the initial query
        query = joins(:scheme, :host_name).where(
          scheme:    {name: uri.scheme},
          host_name: {name: uri.host},
          path:      normalized_path(uri),
          query:     uri.query,
          fragment:  uri.fragment
        )

        if uri.port
          # query the port
          query = query.joins(:port).where(port: {number: uri.port})
        end

        return query.first
      end

      #
      # Creates a new URL.
      #
      # @param [String, URI::HTTP] uri
      #   The URI to create the URL from.
      #
      # @return [URL]
      #   The new URL.
      #
      # @api public
      #
      def self.import(uri)
        uri = URI(uri)

        # find or create the URL scheme, host_name and port
        scheme    = URLScheme.find_or_create_by(name: uri.scheme)
        host_name = HostName.find_or_create_by(name: uri.host)
        port      = if uri.port
                      Port.find_or_create_by(
                        protocol: :tcp,
                        number:   uri.port
                      )
                    end
        path      = normalized_path(uri)
        query     = uri.query
        fragment  = uri.fragment

        # try to query a pre-existing URI then fallback to creating the URL
        # with query params.
        return find_or_create_by(
          scheme:       scheme,
          host_name:    host_name,
          port:         port,
          path:         path,
          query:        query,
          fragment:     fragment
        ) do |new_url|
          if uri.respond_to?(:query_params)
            # find or create the URL query params
            uri.query_params.each do |name,value|
              new_url.query_params << URLQueryParam.new(
                name:  URLQueryParamName.find_or_create_by(name: name),
                value: value
              )
            end
          end
        end
      end

      #
      # The host name of the URL.
      #
      # @return [String]
      #   The address of host name.
      #
      # @api public
      #
      def host
        self.host_name.name
      end

      #
      # The port number used by the URL.
      #
      # @return [Integer, nil]
      #   The port number.
      #
      # @api public
      #
      def port_number
        self.port.number if self.port
      end

      #
      # Builds a URI object from the URL.
      #
      # @return [URI::HTTP, URI::HTTPS]
      #   The URI object created from the URL attributes.
      #
      # @api public
      #
      def to_uri
        # map the URL scheme to a URI class
        url_class = SCHEMES.fetch(self.scheme.name,::URI::Generic)

        scheme = if self.scheme
                   self.scheme.name
                 end

        host = if self.host_name
                 self.host_name.name
               end

        port = if self.port
                 self.port.number
               end

        # build the URI
        return url_class.build(
          scheme:   scheme,
          host:     host,
          port:     port,
          path:     self.path,
          query:    self.query,
          fragment: self.fragment
        )
      end

      #
      # Converts the URL to a String.
      #
      # @return [String]
      #   The string form of the URL.
      #
      # @api public
      #
      def to_s
        self.to_uri.to_s
      end

      #
      # Normalizes the path of a URI.
      #
      # @param [URI] uri
      #   The URI containing the path.
      #
      # @return [String, nil]
      #   The normalized path.
      #
      # @api private
      #
      def self.normalized_path(uri)
        case uri
        when ::URI::HTTP
          # map empty HTTP paths to '/'
          unless uri.path.empty? then uri.path
          else                        '/'
          end
        else
          uri.path
        end
      end

    end
  end
end

require 'ronin/db/host_name'
require 'ronin/db/port'
require 'ronin/db/url_scheme'
require 'ronin/db/url_query_param_name'
require 'ronin/db/url_query_param'
require 'ronin/db/web_credential'
require 'ronin/db/vulnerability'
