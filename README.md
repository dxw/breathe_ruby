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

```ruby
client.absences.list
#=> [
#  {
#    "employee"=>{"id"=>123, "email"=>"someone@somewhere.com", "first_name"=>"Jo", "last_name"=>"Bloggs"},
#    "approved_by"=>{"id"=>123, "first_name"=>"Jo", "last_name"=>"Bloggs"},
#   "leave_reason"=>nil,
#    "deducted"=>"4.0",
#    "work_units"=>"4.0",
#    "id"=>456,
#    "start_date"=>"2015-06-18",
#    "half_start"=>false,
#    "half_start_am_pm"=>nil,
#    "end_date"=>"2015-06-23",
#    "half_end"=>false,
#    "half_end_am_pm"=>nil,
#    "cancelled"=>true,
#    "notes"=>"",
#    "type"=>"Holiday",
#    "created_at"=>"2015-05-20T15:53:36+01:00",
#    "updated_at"=>"2015-06-11T13:58:27+01:00"
#  },
#  ...
#]
```

You can also pass in arguments like so:

```ruby
client.absences(per_page: 12, start_date: Date.today)
#=> [...]
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
