# ronin-db-activerecord

[![CI](https://github.com/ronin-rb/ronin-db-activerecord/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-db-activerecord/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-db-activerecord.svg)](https://codeclimate.com/github/ronin-rb/ronin-db-activerecord)
[![Gem Version](https://badge.fury.io/rb/ronin-db-activerecord.svg)](https://badge.fury.io/rb/ronin-db-activerecord)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-db-activerecord)
* [Issues](https://github.com/ronin-rb/ronin-db-activerecord/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-db-activerecord/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-db-activerecord contains [ActiveRecord] models and migrations for the
[Ronin Database][ronin-db].

## Features

* Can be used both as a standalone library or in a web app.
* Provides common [ActiveRecord] models:
  * [Ronin::DB::Advisory]
  * [Ronin::DB::Arch]
  * [Ronin::DB::ASN]
  * [Ronin::DB::Cert]
  * [Ronin::DB::CertIssuer]
  * [Ronin::DB::CertName]
  * [Ronin::DB::CertSubject]
  * [Ronin::DB::CertSubjectAltName]
  * [Ronin::DB::EmailAddress]
  * [Ronin::DB::HostName]
  * [Ronin::DB::HostNameIPAddress]
  * [Ronin::DB::HTTPHeaderName]
  * [Ronin::DB::HTTPQueryParam]
  * [Ronin::DB::HTTPQueryParamName]
  * [Ronin::DB::HTTPRequest]
  * [Ronin::DB::HTTPRequestHeader]
  * [Ronin::DB::HTTPResponse]
  * [Ronin::DB::HTTPResponseHeader]
  * [Ronin::DB::IPAddress]
  * [Ronin::DB::IPAddressMACAddress]
  * [Ronin::DB::MACAddress]
  * [Ronin::DB::Note]
  * [Ronin::DB::OpenPort]
  * [Ronin::DB::Organization]
  * [Ronin::DB::OS]
  * [Ronin::DB::OSGuess]
  * [Ronin::DB::Password]
  * [Ronin::DB::Person]
  * [Ronin::DB::PhoneNumber]
  * [Ronin::DB::Port]
  * [Ronin::DB::Service]
  * [Ronin::DB::ServiceCredential]
  * [Ronin::DB::Software]
  * [Ronin::DB::SoftwareVendor]
  * [Ronin::DB::StreetAddress]
  * [Ronin::DB::URL]
  * [Ronin::DB::URLQueryParam]
  * [Ronin::DB::URLQueryParamName]
  * [Ronin::DB::URLScheme]
  * [Ronin::DB::UserName]
  * [Ronin::DB::Vulnerability]
  * [Ronin::DB::WebVuln]
  * [Ronin::DB::WebCredential]
* Has 98% documentation coverage.
* Has 99% test coverage.

[Ronin::DB::Advisory]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Advisory.html
[Ronin::DB::Arch]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Arch.html
[Ronin::DB::ASN]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/ASN.html
[Ronin::DB::Cert]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Cert.html
[Ronin::DB::CertIssuer]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/CertIssuer.html
[Ronin::DB::CertName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/CertName.html
[Ronin::DB::CertSubject]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/CertSubject.html
[Ronin::DB::CertSubjectAltName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/CertSubjectAltName.html
[Ronin::DB::EmailAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/EmailAddress.html
[Ronin::DB::HostName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HostName.html
[Ronin::DB::HostNameIPAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HostNameIPAddress.html
[Ronin::DB::HTTPHeaderName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPHeaderName.html
[Ronin::DB::HTTPQueryParam]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPQueryParam.html
[Ronin::DB::HTTPQueryParamName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPQueryParamName.html
[Ronin::DB::HTTPRequest]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPRequest.html
[Ronin::DB::HTTPRequestHeader]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPRequestHeader.html
[Ronin::DB::HTTPResponse]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPResponse.html
[Ronin::DB::HTTPResponseHeader]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/HTTPResponseHeader.html
[Ronin::DB::IPAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/IPAddress.html
[Ronin::DB::IPAddressMACAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/IPAddressMACAddress.html
[Ronin::DB::MACAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/MACAddress.html
[Ronin::DB::Note]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Note.html
[Ronin::DB::OpenPort]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/OpenPort.html
[Ronin::DB::Organization]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Organization.html
[Ronin::DB::OS]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/OS.html
[Ronin::DB::OSGuess]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/OSGuess.html
[Ronin::DB::Password]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Password.html
[Ronin::DB::Person]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Person.html
[Ronin::DB::PhoneNumber]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/PhoneNumber.html
[Ronin::DB::Port]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Port.html
[Ronin::DB::Service]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Service.html
[Ronin::DB::ServiceCredential]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/ServiceCredential.html
[Ronin::DB::Software]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Software.html
[Ronin::DB::SoftwareVendor]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/SoftwareVendor.html
[Ronin::DB::StreetAddress]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/StreetAddress.html
[Ronin::DB::URL]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/URL.html
[Ronin::DB::URLQueryParam]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/URLQueryParam.html
[Ronin::DB::URLQueryParamName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/URLQueryParamName.html
[Ronin::DB::URLScheme]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/URLScheme.html
[Ronin::DB::UserName]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/UserName.html
[Ronin::DB::Vulnerability]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/Vulnerability.html
[Ronin::DB::WebVuln]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/WebVuln.html
[Ronin::DB::WebCredential]: https://ronin-rb.dev/docs/ronin-db-activerecord/Ronin/DB/WebCredential.html

## Examples

Create a database:

```ruby
require 'ronin/db/migrations'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'path/to/db.sqlite3'
)

Ronin::DB::Migrations.up
```

Connect to the database:

```ruby
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'path/to/db.sqlite3'
)

require 'ronin/db/models'
Ronin::DB::Models.connect
```

## Requirements

* [Ruby] >= 3.0.0
* [activerecord] ~> 7.0

## Install

```shell
$ gem install ronin-db-activerecord
```

### Gemfile

```ruby
gem 'ronin-db-activerecord', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-db-activerecord', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-db-activerecord/fork)
2. Clone It!
3. `cd ronin-db-activerecord/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

If you want to test your changes locally, run `rake db:console` to start a
local database console.

## License

Copyright (c) 2022-2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-db-activerecord is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-db-activerecord is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-db-activerecord.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[ActiveRecord]: https://guides.rubyonrails.org/active_record_basics.html
[activerecord]: https://github.com/rails/rails/tree/main/activerecord#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
