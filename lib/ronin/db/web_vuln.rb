# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'model'
require 'active_record'

module Ronin
  module DB
    #
    # Represents discovered web vulnerabilities.
    #
    class WebVuln < ActiveRecord::Base

      include Model

      # @!attribute [rw] id
      #   The primary key of the URL.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] scheme
      #   The scheme of the URL.
      #
      #   @return [URL]
      belongs_to :url, required:   true,
                       class_name: 'URL'

      # @!attribute [rw] type
      #   The type of vuln.
      #
      #   @return ["lfi", "rfi", "sqli", "ssti", "open_redirect", "reflected_xss", "command_injection"]
      attribute :type, :string
      validates :type, presence: true,
                       inclusion: {
                         in: %w[
                           lfi
                           rfi
                           sqli
                           ssti
                           open_redirect
                           reflected_xss
                           command_injection
                         ]
                       }

      # @!attribute [rw] query_param
      #   The query param of the URL.
      #
      #   @return [String, nil]
      attribute :query_param, :string

      # @!attribute [rw] header_name
      #   The header name string part of the URL.
      #
      #   @return [String, nil]
      attribute :header_name, :string

      # @!attribute [rw] cookie_param
      #   The cookie param of the URL.
      #
      #   @return [String, nil]
      attribute :cookie_param, :string

      # @!attribute [rw] form_param
      #   The form param of the URL.
      #
      #   @return [String, nil]
      attribute :form_param, :string
      validate :param_validation

      # @!attribute [rw] request_method
      #   The request method for the URL.
      #
      #   @return ["COPY", "DELETE", "GET", "HEAD", "LOCK", "MKCOL", "MOVE", "OPTIONS", "PATCH", "POST", "PROPFIND", "PROPPATCH", "PUT", "TRACE", "UNLOCK"]
      attribute :request_method, :string
      validates :request_method, presence: true,
                                 inclusion: {
                                   in: %w[
                                     COPY
                                     DELETE
                                     GET
                                     HEAD
                                     LOCK
                                     MKCOL
                                     MOVE
                                     OPTIONS
                                     PATCH
                                     POST
                                     PROPFIND
                                     PROPPATCH
                                     PUT
                                     TRACE
                                     UNLOCK
                                   ]
                                 }

      # @!attribute [rw] lfi_os
      #   The LFI os.
      #
      #   @return [:unix, :windows, nil]
      attribute :lfi_os, :string
      validates :lfi_os, allow_nil: true,
                         inclusion: {in: %w[unix windows]}

      # @!attribute [rw] lfi_depth
      #   The LFI depth.
      #
      #   @return [Integer, nil]
      attribute :lfi_depth, :integer

      # @!attribute [rw] lfi_filter_bypass
      #   The LFI filter bypass.
      #
      #   @return [:null_byte, :base64, :rot13, :zlib, nil]
      attribute :lfi_filter_bypass, :string
      validates :lfi_filter_bypass, allow_nil: true,
                                    inclusion: {
                                      in: %w[
                                        null_byte
                                        base64
                                        rot13
                                        zlib
                                      ]
                                    }

      # @!attribute [rw] rfi_script_lang
      #   The RFI script lang.
      #
      #   @return [:asp, :asp_net, :cold_fusion, :jsp, :php, :perl, nil]
      attribute :rfi_script_lang, :string
      validates :rfi_script_lang, allow_nil: true,
                                  inclusion: {
                                    in: %w[
                                      asp
                                      asp_net
                                      cold_fusion
                                      jsp
                                      php
                                      perl
                                    ]
                                  }

      # @!attribute [rw] rfi_filter_bypass
      #   The RFI filter bypass.
      #
      #   @return [:null_byte, :double_encode, nil]
      attribute :rfi_filter_bypass, :string
      validates :rfi_filter_bypass, allow_nil: true,
                                    inclusion: {in: %w[null_byte double_encode]}

      # @!attribute [rw] ssti_escape_type
      #   The SSTI escape type.
      #
      #   @return [:double_curly_braces, :dollar_curly_braces, :dollar_double_curly_braces, :pound_curly_braces, :angle_brackets_percent, :custom, nil]
      attribute :ssti_escape_type, :string
      validates :ssti_escape_type, allow_nil: true,
                                   inclusion: {
                                     in: %w[
                                       double_curly_braces
                                       dollar_curly_braces
                                       dollar_double_curly_braces
                                       pound_curly_braces
                                       angle_brackets_percent
                                       custom
                                     ]
                                   }

      # @!attribute [rw] sqli_escape_quote
      #   The SQLi escape quote.
      #
      #   @return [Boolean, nil]
      attribute :sqli_escape_quote, :boolean

      # @!attribute [rw] sqli_escape_parens
      #   The SQLi escape parens.
      #
      #   @return [Boolean, nil]
      attribute :sqli_escape_parens, :boolean

      # @!attribute [rw] sqli_terminate
      #   The SQLi terminate.
      #
      #   @return [Boolean, nil]
      attribute :sqli_terminate, :boolean

      # @!attribute [rw] command_injection_escape_quote
      #   The Command Injection escape quote character.
      #
      #   @return [String, nil]
      attribute :command_injection_escape_quote, :string

      # @!attribute [rw] command_injection_escape_operator
      #   The Command Injection escape operator character.
      #
      #   @return [String, nil]
      attribute :command_injection_escape_operator, :string

      # @!attribute [rw] command_injection_terminator
      #   The Command Injection terminator character.
      #
      #   @return [String, nil]
      attribute :command_injection_terminator, :string

      # @!attribute [r] created_at
      #   Defines the created_at timestamp
      #
      #   @return [Time]
      attribute :created_at, :datetime

      #
      # Queries all web vulnerabilities belonging to the given host name.
      #
      # @param [String] host_name
      #   The host name to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.for_host(host_name)
        joins(url: [:host_name]).where(
          url: {
            ronin_host_names: {name: host_name}
          }
        )
      end

      #
      # Queries all web vulnerabilities belonging to the given domain name.
      #
      # @param [String] domain
      #   The domain to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.for_domain(domain)
        joins(url: [:host_name]).merge(HostName.with_domain(domain))
      end

      #
      # Queries all web vulnerabilities with the matching URL path.
      #
      # @param [String] path
      #   The URL path to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.for_path(path)
        joins(:url).where(url: {path: path})
      end

      #
      # Queries all web vulnerabilities of the given type.
      #
      # @param [:lfi, :rfi, :sqli, :ssti, :open_redirect, :reflected_xss, :command_injection] type
      #   The web vulnerability type to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_type(type)
        where(type: type)
      end

      #
      # Queries all web vulnerabilities effecting the given query param name.
      #
      # @param [String] name
      #   The query param name to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_query_param(name)
        where(query_param: name)
      end

      #
      # Queries all web vulnerabilities effecting the given header name.
      #
      # @param [String] name
      #   The header name to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_header_name(name)
        where(header_name: name)
      end

      #
      # Queries all web vulnerabilities effecting the given cookie param name.
      #
      # @param [String] name
      #   The cookie param name to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_cookie_param(name)
        where(cookie_param: name)
      end

      #
      # Queries all web vulnerabilities effecting the given form param name.
      #
      # @param [String] name
      #   The form param name to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_form_param(name)
        where(form_param: name)
      end

      #
      # Queries all web vulnerabilities with the given request method.
      #
      # @param [String] request_method
      #   The request method to search for.
      #
      # @return [Array<WebVuln>]
      #   The matching web vulnerabilities.
      #
      def self.with_request_method(request_method)
        where(request_method: request_method)
      end

      #
      # Validates presence of at least one param fields.
      #
      def param_validation
        unless (query_param || header_name || cookie_param || form_param)
          self.errors.add(:base, "query_param, header_name, cookie_param or from_param must be present")
        end
      end

      #
      # Determines if the web vulnerability is a LFI vulnerability.
      #
      # @return [Boolean]
      #
      def lfi?
        self.type == 'lfi'
      end

      #
      # Determines if the web vulnerability is a RFI vulnerability.
      #
      # @return [Boolean]
      #
      def rfi?
        self.type == 'rfi'
      end

      #
      # Determines if the web vulnerability is a SQLi vulnerability.
      #
      # @return [Boolean]
      #
      def sqli?
        self.type == 'sqli'
      end

      #
      # Determines if the web vulnerability is a SSTI vulnerability.
      #
      # @return [Boolean]
      #
      def ssti?
        self.type == 'ssti'
      end

      #
      # Determines if the web vulnerability is a Open Redirect vulnerability.
      #
      # @return [Boolean]
      #
      def open_redirect?
        self.type == 'open_redirect'
      end

      #
      # Determines if the web vulnerability is a Reflected XSS vulnerability.
      #
      # @return [Boolean]
      #
      def reflected_xss?
        self.type == 'reflected_xss'
      end

      #
      # Determines if the web vulnerability is a Command Injection
      # vulnerability.
      #
      # @return [Boolean]
      #
      def command_injection?
        self.type == 'command_injection'
      end

      #
      # Determines if the web vulnerability sends a HTTP COPY request.
      #
      # @return [Boolean]
      #
      def copy_request?
        self.request_method == 'COPY'
      end

      #
      # Determines if the web vulnerability sends a HTTP DELETE request.
      #
      # @return [Boolean]
      #
      def delete_request?
        self.request_method == 'DELETE'
      end

      #
      # Determines if the web vulnerability sends a HTTP GET request.
      #
      # @return [Boolean]
      #
      def get_request?
        self.request_method == 'GET'
      end

      #
      # Determines if the web vulnerability sends a HTTP HEAD request.
      #
      # @return [Boolean]
      #
      def head_request?
        self.request_method == 'HEAD'
      end

      #
      # Determines if the web vulnerability sends a HTTP LOCK request.
      #
      # @return [Boolean]
      #
      def lock_request?
        self.request_method == 'LOCK'
      end

      #
      # Determines if the web vulnerability sends a HTTP MKCOL request.
      #
      # @return [Boolean]
      #
      def mkcol_request?
        self.request_method == 'MKCOL'
      end

      #
      # Determines if the web vulnerability sends a HTTP MOVE request.
      #
      # @return [Boolean]
      #
      def move_request?
        self.request_method == 'MOVE'
      end

      #
      # Determines if the web vulnerability sends a HTTP OPTIONS request.
      #
      # @return [Boolean]
      #
      def options_request?
        self.request_method == 'OPTIONS'
      end

      #
      # Determines if the web vulnerability sends a HTTP PATCH request.
      #
      # @return [Boolean]
      #
      def patch_request?
        self.request_method == 'PATCH'
      end

      #
      # Determines if the web vulnerability sends a HTTP POST request.
      #
      # @return [Boolean]
      #
      def post_request?
        self.request_method == 'POST'
      end

      #
      # Determines if the web vulnerability sends a HTTP PROPFIND request.
      #
      # @return [Boolean]
      #
      def propfind_request?
        self.request_method == 'PROPFIND'
      end

      #
      # Determines if the web vulnerability sends a HTTP PROPPATCH request.
      #
      # @return [Boolean]
      #
      def proppatch_request?
        self.request_method == 'PROPPATCH'
      end

      #
      # Determines if the web vulnerability sends a HTTP PUT request.
      #
      # @return [Boolean]
      #
      def put_request?
        self.request_method == 'PUT'
      end

      #
      # Determines if the web vulnerability sends a HTTP TRACE request.
      #
      # @return [Boolean]
      #
      def trace_request?
        self.request_method == 'TRACE'
      end

      #
      # Determines if the web vulnerability sends a HTTP UNLOCK request.
      #
      # @return [Boolean]
      #
      def unlock_request?
        self.request_method == 'UNLOCK'
      end

    end
  end
end

require_relative 'url'
