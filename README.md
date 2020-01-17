# Breathe

A Ruby Wrapper for the BreateHR API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'breathe'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install breathe
```

## Usage

Require the gem:

```ruby
require "breathe"
```

Initialize the client like so:

```ruby
client = Breathe::Client.new(api_key: YOUR_API_KEY)
```

And use like so

### List absences (Holiday and Other leave)

```ruby
client.absences.list
#=> [...]
```

### List sicknesses

```ruby
client.sicknesses.list
#=> [...]
```

### List employees

```ruby
client.employees.list
#=> [...]
```

### Get an employee by ID

```ruby
client.employees.get(id)
#=> [...]
```

### Filtering

You can also pass in arguments like so:

```ruby
client.absences(per_page: 12, start_date: Date.today)
#=> [...]
```

### Pagination

You can also paginate through the data like so:

```ruby
client.absences.list.next_page
#=> [...]
client.absences.list.previous_page
#=> [...]
client.absences.list.last_page
#=> [...]
client.absences.list.first_pages
#=> [..]
```

If you don't want to paginate at all, you can initialize the client with the `auto_paginate` argument set to `true` like so:

```ruby
client = Breathe::Client.new(api_key: YOUR_API_KEY, auto_paginate: true)
```

Only the absences endpoint is currently supported. PRs are accepted for more endpoints!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/breathe. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Breathe project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/breathe/blob/master/CODE_OF_CONDUCT.md).
