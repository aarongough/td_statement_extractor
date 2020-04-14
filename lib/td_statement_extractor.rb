require "td_statement_extractor/version"

class TdStatementExtractor
  class << self

    DATE1_REGEX = /(?<date1>(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s[0-9]+)/
    DATE2_REGEX = /(?<date2>(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s[0-9]+)/
    AMOUNT_REGEX = /(?<amount>-?\$\d+\.\d+)/
    DESCRIPTION_REGEX = /#{DATE1_REGEX}\s+#{DATE2_REGEX}?\s+(?<description>.+)\s+#{AMOUNT_REGEX}/

    def extract(input_file, output_file)

    end

    def transaction_line?(line)
      line.match?(DATE1_REGEX) && line.match?(AMOUNT_REGEX)
    end

    def data_from_line(line)
      begin
        date = line.match(DATE1_REGEX)[:date1]
        amount = line.match(AMOUNT_REGEX)[:amount]
        description = line.match(DESCRIPTION_REGEX)[:description].strip
      rescue NoMethodError
        raise(RuntimeError, "Error extracting data from line: #{line}")
      end

      raise RuntimeError, "Error extracting data from line: #{line}" if description.empty?

      { date: date, description: description, amount: amount }
    end

  end
end
