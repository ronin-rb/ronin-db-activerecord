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

      # @!attribute [rw] query_params
      #   The query params of the URL.
      #
      #   @return [Array<URLQueryParam>]
      has_many :query_params, class_name: 'URLQueryParam'

      # @!attribute [rw] web_credentials
      #   Any credentials used with the URL.
      #
      #   @return [Array<WebCredential>]
      has_many :web_credentials

      # @!attribute [r] created_at
      #   Defines the created_at timestamp
      #
      #   @return [Time]
      attribute :created_at, :time

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
        joins(:scheme).all(scheme: {name: 'https'})
      end

      #
      # Searches for URLs with specific host name(s).
      #
      # @param [Array<String>, String] names
      #   The host name(s) to search for.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.with_hosts(names)
        joins(:host).where(host: {address: names})
      end

      #
      # Searches for URLs with the specific port number(s).
      #
      # @param [Array<Integer>, Integer] numbers
      #   The port numbers to search for.
      #
      # @return [Array<URL>]
      #   The matching URLs.
      #
      # @api public
      #
      def self.with_ports(numbers)
        joins(:port).where(port: {number: numbers})
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

        where(path: root_dir).or(where(path_column.match("#{root_dir}/%")))
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
      def self.with_ext(ext)
        path_column = self.arel_table[:path]

        where(path_column.matches("%.#{sanitize_sql_like(ext)}"))
      end

      #
      # Searches for URLs with the given query param.
      #
      # @param [Array<String>, String] name
      #   The query param name to search for.
      #
      # @return [Array<URL>]
      #   The URLs with the given query param.
      #
      # @api public
      #
      def self.with_query_param(name)
        joins(query_params: [:name]).where(query_params: {name: {name: name}})
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
      def self.with_query_value(value)
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
      def self.find_url(url)
        # optionally parse the URL
        url = ::URI.parse(url.to_s) unless url.kind_of?(::URI)

        # create the initial query
        query = joins(:scheme, :host_name).where(
          scheme:    {name: url.scheme},
          host_name: {name: url.host},
          path:      normalized_path(url),
          query:     url.query,
          fragment:  url.fragment
        )

        if url.port
          # query the port
          query = query.joins(:port).where(port: {number: url.port})
        end

        if url.query
          query = query.joins(:query_param, query_param: [:name])

          # add the query params to the query
          ::URI::QueryParams.parse(url.query).each do |name,value|
            query = query.where(
              query_params: {
                name:  {name: name},
                value: value
              }
            )
          end
        end

        return query.first
      end

      #
      # Creates a new URL.
      #
      # @param [URI::HTTP] uri
      #   The URI to create the URL from.
      #
      # @return [URL]
      #   The new URL.
      #
      # @api public
      #
      def self.from(uri)
        # find or create the URL scheme, host_name and port
        scheme    = URLScheme.find_or_initialize_by(name: uri.scheme)
        host_name = HostName.find_or_initialize_by(name: uri.host)
        port      = if uri.port
                      Port.find_or_initialize_by(
                        protocol: :tcp,
                        number:   uri.port
                      )
                    end

        path     = normalized_path(uri)
        query    = uri.query
        fragment = uri.fragment

        query_params = []
        
        if uri.respond_to?(:query_params)
          # find or create the URL query params
          uri.query_params.each do |name,value|
            query_params << URLQueryParam.new(
              name:  URLQueryParamName.find_or_initialize_by(name: name),
              value: value
            )
          end
        end

        # find or create the URL
        return find_or_initialize_by(
          scheme:       scheme,
          host_name:    host_name,
          port:         port,
          path:         path,
          query:        query,
          fragment:     fragment,
          query_params: query_params
        )
      end

      #
      # Parses the URL.
      #
      # @param [String] url
      #   The raw URL to parse.
      #
      # @return [URL]
      #   The parsed URL.
      #
      # @see URL.from
      #
      # @api public
      #
      def self.parse(url)
        from(::URI.parse(url))
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

        host = if self.host_name
                 self.host_name.name
               end
        port = if self.port
                 self.port.number
               end

        query = unless self.query_params.empty?
                  self.query_string
                end

        # build the URI
        return url_class.build(
          scheme:   self.scheme.name,
          host:     host,
          port:     port,
          path:     self.path,
          query:    query,
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

      protected

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

require 'ronin/db/url_scheme'
require 'ronin/db/url_query_param_name'
require 'ronin/db/url_query_param'
require 'ronin/db/host_name'
require 'ronin/db/port'
