### 0.1.5 / 2023-12-13

* Corrected {Ronin::DB::HTTPRequest#request_method} to accept and store
  uppercase HTTP verbs (ex: `GET`).
* Corrected {Ronin::DB::HTTPRequest#request_method} helper methods to use the
  singular suffix of `_request?` (ex: `get_request?`).

### 0.1.4 / 2023-10-16

* Require [activerecord] `~> 7.0`.
* Switched to using the default `schema_migrations` table for storing migration
  versions and avoid using ActiveRecord's private API.

### 0.1.3 / 2023-10-14

* Require [activerecord] `~> 7.0, < 7.1.0`.
  * **Note:** [activerecord] 7.1.0 changed it's internal migration APIs which
    `ronin-db-activerecord` was using to run migrations.

### 0.1.2 / 2023-09-19

* Fix {Ronin::DB::MACAddress#address} validation regex to match the whole
  string.
* Use `:datetime` instead of `:time` for `created_at` attributes.
* Documentation improvements.

### 0.1.1 / 2023-04-04

* Reordered database migrations so they can be ran in correct order on
  PostgreSQL databases.
* Fixed {Ronin::DB::URL.import} to correctly de-duplicate pre-existing URLs.
* Fixed `ronin_advisories.publisher` index on non-existent column.
* Added an index on the `ronin_advisories.identifier` column.
* Added missing unique index to `ronin_urls` table.
* Documentation improvements.

### 0.1.0 / 2023-02-01

* Initial release:
  * Can be used both as a standalone library or in a web app.
  * Provides common [ActiveRecord] models:
    * {Ronin::DB::Advisory}
    * {Ronin::DB::Arch}
    * {Ronin::DB::ASN}
    * {Ronin::DB::EmailAddress}
    * {Ronin::DB::HostName}
    * {Ronin::DB::HostNameIPAddress}
    * {Ronin::DB::HTTPHeaderName}
    * {Ronin::DB::HTTPQueryParam}
    * {Ronin::DB::HTTPQueryParamName}
    * {Ronin::DB::HTTPRequest}
    * {Ronin::DB::HTTPRequestHeader}
    * {Ronin::DB::HTTPResponse}
    * {Ronin::DB::HTTPResponseHeader}
    * {Ronin::DB::IPAddress}
    * {Ronin::DB::IPAddressMACAddress}
    * {Ronin::DB::MACAddress}
    * {Ronin::DB::OpenPort}
    * {Ronin::DB::Organization}
    * {Ronin::DB::OS}
    * {Ronin::DB::OSGuess}
    * {Ronin::DB::Password}
    * {Ronin::DB::Port}
    * {Ronin::DB::Service}
    * {Ronin::DB::ServiceCredential}
    * {Ronin::DB::Software}
    * {Ronin::DB::SoftwareVendor}
    * {Ronin::DB::URL}
    * {Ronin::DB::URLQueryParam}
    * {Ronin::DB::URLQueryParamName}
    * {Ronin::DB::URLScheme}
    * {Ronin::DB::UserName}
    * {Ronin::DB::Vulnerability}
    * {Ronin::DB::WebCredential}

[activerecord]: https://github.com/rails/rails/tree/main/activerecord#readme
