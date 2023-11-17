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
require 'active_record'

module Ronin
  module DB
    #
    # Represents parsed URLs.
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
      #   @return [:copy, :delete, :get, :head, :lock, :mkcol, :move, :options, :patch, :post, :propfind, :proppatch, :put, :trace, :unlock]
      enum request_method: [
        :copy,
        :delete,
        :get,
        :head,
        :lock,
        :mkcol,
        :move,
        :options,
        :patch,
        :post,
        :propfind,
        :proppatch,
        :put,
        :trace,
        :unlock
      ], _suffix: :requests

      # @!attribute [rw] lfi_os
      #   The lfi os.
      #
      #   @return [:unix, :windows, nil]
      enum lfi_os: [:unix, :windows]

      # @!attribute [rw] lfi_depth
      #   The lfi depth.
      #
      #   @return [Integer, nil]
      attribute :lfi_depth, :integer

      # @!attribute [rw] lfi_filter_bypass
      #   The lfi filter bypass.
      #
      #   @return [:null_byte, :base64, :rot13, :zlib, nil]
      enum lfi_filter_bypass: [:lfi_null_byte, :base64, :rot13, :zlib]

      # @!attribute [rw] rfi_script_lang
      #   The rfi script lang.
      #
      #   @return [:asp, :asp_net, :cold_fusion, :jsp, :php, :perl, nil]
      enum rfi_script_lang: [:asp, :asp_net, :cold_fusion, :jsp, :php, :perl]

      # @!attribute [rw] rfi_filter_bypass
      #   The rfi filter bypass.
      #
      #   @return [:null_byte, :double_encode, nil]
      enum rfi_filter_bypass: [:rfi_null_byte, :double_encode]

      # @!attribute [rw] rfi_filter_bypass
      #   The rfi filter bypass.
      #
      #   @return [:null_byte, :double_encode, nil]
      enum ssti_escape: [:foo, :erb] # ! https://github.com/ronin-rb/ronin-vulns/issues/55

      # @!attribute [rw] sqli_escape_quote
      #   The sqli escape quote.
      #
      #   @return [Boolean, nil]
      attribute :sqli_escape_quote, :boolean

      # @!attribute [rw] sqli_escape_parens
      #   The sqli escape parens.
      #
      #   @return [Boolean, nil]
      attribute :sqli_escape_parens, :boolean

      # @!attribute [rw] sqli_terminate
      #   The sqli terminate.
      #
      #   @return [Boolean, nil]
      attribute :sqli_terminate, :boolean

      # @!attribute [r] created_at
      #   Defines the created_at timestamp
      #
      #   @return [Time]
      attribute :created_at, :datetime

      def param_validation
        unless [:query_param, :header_name, :cookie_param, :form_param].any? { |field| self.send(field).present? }
          self.errors.add(:base, "query_param, header_name, cookie_param or from_param must be present")
        end
      end

    end
  end
end
