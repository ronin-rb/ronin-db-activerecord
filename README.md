# ronin-db-activerecord

[![CI](https://github.com/ronin-rb/ronin-db-activerecord/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-db-activerecord/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-db-activerecord.svg)](https://codeclimate.com/github/ronin-rb/ronin-db-activerecord)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-db-activerecord)
* [Issues](https://github.com/ronin-rb/ronin-db-activerecord/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-db-activerecord/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb)

## Description

ronin-db-activerecord contains [ActiveRecord] models and migrations for the
[Ronin Database][ronin-db].

## Features

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

Copyright (c) 2022 Hal Brodigan (postmodern.mod3@gmail.com)

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
