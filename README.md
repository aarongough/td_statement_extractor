[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)
[![build](https://github.com/aarongough/td_statement_extractor/actions/workflows/ruby.yml/badge.svg)](https://github.com/aarongough/td_statement_extractor/actions/workflows/ruby.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/8a22ae11816d0eebfd85/maintainability)](https://codeclimate.com/github/aarongough/td_statement_extractor/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8a22ae11816d0eebfd85/test_coverage)](https://codeclimate.com/github/aarongough/td_statement_extractor/test_coverage)
[![Gem Version](https://badge.fury.io/rb/td_statement_extractor.svg)](https://badge.fury.io/rb/td_statement_extractor)

# TD Statement Extractor

Extract machine readable transaction data from TD credit card statements. Useful for importing data quickly into a bookkeeping or accounting system!

## Installation

Install from the command line:

    $ gem install td_statement_extractor

## Usage

    td_statement_extractor INPUT_FILE OUTPUT_FILE

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aarongough/td_statement_extractor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
