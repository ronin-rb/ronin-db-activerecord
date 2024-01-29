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

require 'ronin/db/model'
require 'active_record'

module Ronin
  module DB
    #
    # Represents discovered web vulnerabilities.
    #
    class WebVuln < ActiveRecord::Base

      include Model

      # NOTE: disable STI so we can use the type column as an enum.
      self.inheritance_column = nil

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
      enum type: {
        lfi:               'lfi',
        rfi:               'rfi',
        sqli:              'sqli',
        ssti:              'ssti',
        open_redirect:     'open_redirect',
        reflected_xss:     'reflected_xss',
        command_injection: 'command_injection'
      }
      validates :type, presence: true

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
      #   @return ["copy", "delete", "get", "head", "lock", "mkcol", "move", "options", "patch", "post", "propfind", "proppatch", "put", "trace", "unlock"]
      enum request_method: {
        copy:      'COPY',
        delete:    'DELETE',
        get:       'GET',
        head:      'HEAD',
        lock:      'LOCK',
        mkcol:     'MKCOL',
        move:      'MOVE',
        options:   'OPTIONS',
        patch:     'PATCH',
        post:      'POST',
        propfind:  'PROPFIND',
        proppatch: 'PROPPATCH',
        put:       'PUT',
        trace:     'TRACE',
        unlock:    'UNLOCK'
      }, _suffix: :request

      # @!attribute [rw] lfi_os
      #   The LFI os.
      #
      #   @return [:unix, :windows, nil]
      enum lfi_os: {
        unix:    'unix',
        windows: 'windows'
      }, _prefix: true

      # @!attribute [rw] lfi_depth
      #   The LFI depth.
      #
      #   @return [Integer, nil]
      attribute :lfi_depth, :integer

      # @!attribute [rw] lfi_filter_bypass
      #   The LFI filter bypass.
      #
      #   @return [:null_byte, :base64, :rot13, :zlib, nil]
      enum lfi_filter_bypass: {
        null_byte: 'null_byte',
        base64:    'base64',
        rot13:     'rot13',
        zlib:      'zlib'
      }, _prefix: true

      # @!attribute [rw] rfi_script_lang
      #   The RFI script lang.
      #
      #   @return [:asp, :asp_net, :cold_fusion, :jsp, :php, :perl, nil]
      enum rfi_script_lang: {
        asp:         'asp',
        asp_net:     'asp_net',
        cold_fusion: 'cold_fusion',
        jsp:         'jsp',
        php:         'php',
        perl:        'perl'
      }, _prefix: true

      # @!attribute [rw] rfi_filter_bypass
      #   The RFI filter bypass.
      #
      #   @return [:null_byte, :double_encode, nil]
      enum rfi_filter_bypass: {
        null_byte:     'null_byte',
        double_encode: 'double_encode'
      }, _prefix: true

      # @!attribute [rw] ssti_escape_type
      #   The SSTI escape type.
      #
      #   @return [:double_curly_braces, :dollar_curly_braces, :dollar_double_curly_braces, :pound_curly_braces, :angle_brackets_percent, :custom, nil]
      enum ssti_escape_type: {
        double_curly_braces:        'double_curly_braces',
        dollar_curly_braces:        'dollar_curly_braces',
        dollar_double_curly_braces: 'dollar_double_curly_braces',
        pound_curly_braces:         'pound_curly_braces',
        angle_brackets_percent:     'angle_brackets_percent',
        custom:                     'custom'
      }, _prefix: true

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
      # Validates presence of at least one param fields.
      #
      def param_validation
        unless (query_param || header_name || cookie_param || form_param)
          self.errors.add(:base, "query_param, header_name, cookie_param or from_param must be present")
        end
      end

    end
  end
end
