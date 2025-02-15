### 0.2.1 / 2025-02-14

* Use `require_relative` to improve load times.

### 0.2.0 / 2024-07-22

* Added {Ronin::DB::Advisory#host_names}.
* Added {Ronin::DB::Advisory#ip_addresses}.
* Added {Ronin::DB::Advisory#mac_addresses}.
* Added {Ronin::DB::Advisory#open_ports}.
* Added {Ronin::DB::Advisory#urls}.
* Added {Ronin::DB::Advisory#vulnerabilities}.
* Added {Ronin::DB::ASN#to_s}.
* Added {Ronin::DB::Cert}.
* Added {Ronin::DB::DNSQuery}.
* Added {Ronin::DB::DNSRecord}.
* Added {Ronin::DB::EmailAddress.for_organization}.
* Added {Ronin::DB::EmailAddress.for_person}.
* Added {Ronin::DB::EmailAddress.with_password}.
* Added {Ronin::DB::EmailAddress#passwords}.
* Added {Ronin::DB::EmailAddress#service_credentials}.
* Added {Ronin::DB::EmailAddress#web_credentials}.
* Added {Ronin::DB::HostName#advisories}.
* Added {Ronin::DB::HostName#vulnerabilities}.
* Added {Ronin::DB::HTTPRequest#source_ip}.
* Added {Ronin::DB::IPAddress#advisories}.
* Added {Ronin::DB::IPAddress#vulnerabilities}.
* Added {Ronin::DB::MACAddress#advisories}.
* Added {Ronin::DB::MACAddress#vulnerabilities}.
* Added {Ronin::DB::Model::HasName::ClassMethods#with_name}.
* Added {Ronin::DB::Note}.
* Added {Ronin::DB::OpenPort.with_ip_address}.
* Added {Ronin::DB::OpenPort.with_port_number}.
* Added {Ronin::DB::OpenPort.with_protocol}.
* Added {Ronin::DB::OpenPort.with_service_name}.
* Added {Ronin::DB::OpenPort#advisories}.
* Added {Ronin::DB::OpenPort#vulnerabilities}.
* Added {Ronin::DB::Organization.import}.
* Added {Ronin::DB::Organization.lookup}.
* Added {Ronin::DB::Organization#type}.
* Added {Ronin::DB::Organization#parent}.
* Added {Ronin::DB::OrganizationCustomer}.
* Added {Ronin::DB::OrganizationDepartment}.
* Added {Ronin::DB::OrganizationEmailAddress}.
* Added {Ronin::DB::OrganizationHostName}.
* Added {Ronin::DB::OrganizationIPAddress}.
* Added {Ronin::DB::OrganizationMember}.
* Added {Ronin::DB::OrganizationPhoneNumber}.
* Added {Ronin::DB::OrganizationStreetAddress}.
* Added {Ronin::DB::OS.with_flavor}.
* Added {Ronin::DB::OS.with_version}.
* Added {Ronin::DB::Password.for_user}.
* Added {Ronin::DB::Password.with_email_address}.
* Added {Ronin::DB::Password#email_addresses}.
* Added {Ronin::DB::Password#service_credentials}.
* Added {Ronin::DB::Password#web_credentials}.
* Added {Ronin::DB::Person}.
* Added {Ronin::DB::PersonalConnection}.
* Added {Ronin::DB::PersonalEmailAddress}.
* Added {Ronin::DB::PersonalPhoneNumber}.
* Added {Ronin::DB::PersonalStreetAddress}.
* Added {Ronin::DB::PhoneNumber}.
* Added {Ronin::DB::Port.with_ip_address}.
* Added {Ronin::DB::Port.with_number}.
* Added {Ronin::DB::Port.with_protocol}.
* Added {Ronin::DB::Port.with_service_name}.
* Added {Ronin::DB::Port#ip_addresses}.
* Added {Ronin::DB::Port#services}.
* Added {Ronin::DB::Service.import}.
* Added {Ronin::DB::Service.lookup}.
* Added {Ronin::DB::Service.with_ip_address}.
* Added {Ronin::DB::Service.with_port_number}.
* Added {Ronin::DB::Service.with_protocol}.
* Added {Ronin::DB::Service#ip_addresses}.
* Added {Ronin::DB::Service#ports}.
* Added {Ronin::DB::Software.with_vendor_name}.
* Added {Ronin::DB::Software.with_version}.
* Added {Ronin::DB::StreetAddress}.
* Added {Ronin::DB::URL#advisories}.
* Added {Ronin::DB::URL#vulnerabilities}.
* Added {Ronin::DB::URLQueryParamName.urls}.
* Added {Ronin::DB::UserName#passwords}.
* Added {Ronin::DB::UserName#service_credentials}.
* Added {Ronin::DB::UserName#web_credentials}.
* Added {Ronin::DB::UserName.with_password}.
* Added {Ronin::DB::WebVuln}.
* Include {Ronin::DB::Model::Importable} into {Ronin::DB::Service}.
* Include {Ronin::DB::Model::Importable} into {Ronin::DB::Organization}.
* Include {Ronin::DB::Model::HasName} into {Ronin::DB::Software} for the
  {Ronin::DB::Model::HasName::ClassMethods#named .named} method.
* Added missing `created_at` column and attribute to {Ronin::DB::Port}.
* Added missing `created_at` column and attribute to {Ronin::DB::Service}.
* Changed {Ronin::DB::OpenPort#to_s} to include
  {Ronin::DB::OpenPort#ip_address}.

### 0.1.6 / 2024-06-19

* Improve the validation of email addresses passed to
  {Ronin::DB::EmailAddress.import}.
* Add missing `software_id` column to the `ronin_open_ports` table.
* Add missing `foreign_key` to {Ronin::DB::SoftwareVendor#software}.
* Add missing `class_name` to {Ronin::DB::Vulnerability#url}.
* Add missing `dependent: :destroy` to {Ronin::DB::HostName#urls}.
* Add missing `dependent: :destroy` to {Ronin::DB::HostName#email_addresses}.

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
