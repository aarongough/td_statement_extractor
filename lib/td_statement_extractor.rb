require "td_statement_extractor/version"
require "pdf-reader"
require "date"

class TdStatementExtractor
  class << self

    STATEMENT_DATE = /(?<statement_date>(?<month>[A-Z][a-z]+)\s(?<day>[0-9]+),\s(?<year>[0-9]{4}))/
    MONTH = /(?<month>JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)/
    DAY = /(?<day>[0-9]+)/
    DATE = /(?<date>#{MONTH}\s#{DAY})/
    AMOUNT = /(?<amount>-?\$[,\d]+\.\d+)/
    DESCRIPTION = /#{DATE}\s+#{DATE}?\s+(?<description>.+)\s+#{AMOUNT}/

    def extract_data_from_pdf(input_file_path)
      pdf = PDF::Reader.new(input_file_path)
      text = pdf.pages.map {|page| page.text }.join

      statement_date = text.match(STATEMENT_DATE)&.[](:statement_date)
      raise InvalidStatementDateError, "Unable to extract statement date" if statement_date.nil? || statement_date.empty?

      text.each_line.map do |line|
        next unless transaction_line?(line)
        data = data_from_line(line)
        data[:date] = transform_date(data[:date], statement_date)

        data
      end.compact
    end

    def transaction_line?(line)
      line.match?(DATE) && line.match?(AMOUNT)
    end

    def data_from_line(line)
      date = line.match(DATE)&.[](:date)
      amount = line.match(AMOUNT)&.[](:amount)
      description = line.match(DESCRIPTION)&.[](:description)&.strip

      raise MissingDateError, "Error extracting DATE from line: #{line}" if date.nil? || date.empty?
      raise MissingAmountError, "Error extracting AMOUNT from line: #{line}" if amount.nil? || amount.empty?
      raise MissingDescriptionError, "Error extracting DESCRIPTION from line: #{line}" if description.nil? || description.empty?

      { date: date, description: description, amount: amount }
    end

    def transform_date(date, statement_date)
      month = date.match(MONTH)&.[](:month)
      day = date.match(DAY)&.[](:day)&.to_i
      statement_month = statement_date.match(STATEMENT_DATE)&.[](:month)
      statement_year = statement_date.match(STATEMENT_DATE)&.[](:year)&.to_i

      raise InvalidMonthError, "Error extracting MONTH from date: #{date}" if month.nil? || month.empty?
      raise InvalidDayError, "Error extracting DAY from date: #{date}" if day.zero? || day > 31
      raise InvalidStatementDateError, "Error extracting MONTH from statement date: #{statement_date}" if statement_month.nil? || statement_month.empty?
      raise InvalidStatementDateError, "Error extracting YEAR from statement date: #{statement_date}" if statement_year.nil? || statement_year.zero? || statement_year < 1980 || statement_year > 3000

      if statement_month == "January" && month == "DEC"
        year = statement_year - 1
      else
        year = statement_year
      end

      Date.parse("#{month} #{day} #{year}")
    end
  end

  class MissingDateError < StandardError; end
  class MissingAmountError < StandardError; end
  class MissingDescriptionError < StandardError; end

  class InvalidMonthError < StandardError; end
  class InvalidDayError < StandardError; end
  class InvalidStatementDateError < StandardError; end
end
