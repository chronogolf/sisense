# Sisense

[![Build Status](https://travis-ci.com/chronogolf/sisense.svg?branch=master)](https://travis-ci.com/chronogolf/sisense)

This gem is a wrapper around [Sisense API](https://developers.sisense.com/display/API2/REST+API+Reference+-+v1.0)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sisense"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sisense

## Usage

```ruby
Sisense.access_token = "MyToken"
Sisense.hostname = "bi.chronogolf.com"
Sisense.use_ssl = true

# List all supported resources
Sisense.api_resources
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chronogolf/sisense.

Please make sure to run changes through [Standard ruby](https://github.com/testdouble/standard). `bundle exec standardrb --fix`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
