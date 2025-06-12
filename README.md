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
You can process a single file from the command line like so:

    td_statement_extractor ~/path_to/INPUT_FILE ~/path_to/OUTPUT_FILE.csv

Or you can process a number of files and produce a single CSV output. This is great for processing an entire year's worth of statements and outputting a CSV ready for import into your accounting software come tax time. It is recommended that you only process statements for a single account at a time:

    # Process multiple files using a wildcard operator in the input path
    td_statement_extractor ~/path_to_statements/* ~/path_to/OUTPUT_FILE.csv

    # Process multiple files by listing each file manually
    td_statement_extractor INPUT_FILE_1 INPUT_FILE_2 [etc...] ~/path_to/OUTPUT_FILE.csv

After processing each file the system will generate a summary of the output, including a `Total activity` amount that should match up with the `Total activity` from the PDF statement. This is a great way to sanity check the output of the script and make sure it's accurate:

```
Decrypting and pre-processing file... This may take a minute.
Decryption and pre-processing completed.

Processed file: /Users/SomeGuy/Downloads/TD_EMERALD_FLEX_RATE_VISA__CARD_XXXX.pdf
Details:
  Transactions: 15
  Total activity: $908.41

Transactions:
  Date       | Description                           | Amount   
  -----------|---------------------------------------|----------
  2024-07-15 | PAYMENT - THANK YOU                   | $286.66
  2024-07-18 | GITHUB, INC. HTTPSGITHUB.             | -$5.62
  2024-07-27 | SPOTIFY STOCKHOLM                     | -$12.42
  2024-08-01 | UBER* TRIP HTTPSWWW.UBE               | -$14.34
  2024-08-01 | UBER CANADA/UBERTRIP                  | -$18.56
  2024-08-01 | UBER* TRIP HTTPSWWW.UBE               | -$7.83
  2024-08-01 | PAYMENT - THANK YOU                   | $831.0
  2024-08-02 | Amazon.ca Prime Member amazon.ca/pr   | -$11.29
  2024-08-01 | WAL-MART ONLINE PHOTO                 | -$75.05
  2024-08-02 | UBER CANADA/UBERTRIP                  | -$3.0
  2024-08-02 | UBER CANADA/UBERTRIP                  | -$10.67
  2024-08-02 | UBER CANADA/UBERTRIP                  | -$18.67
  2024-08-06 | PREAUTHORIZED PAYMENT                 | $10.0
  2024-08-09 | INTUIT *QBooks Online                 | -$27.12
  2024-08-13 | GOOGLE *YouTubePremium g.co/helppay   | -$14.68
  -----------|---------------------------------------|----------
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aarongough/td_statement_extractor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
