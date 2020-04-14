require "td_statement_extractor/version"

class TdStatementExtractor
  class << self

    DATE_REGEX = /((JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s[0-9])+.*/
    MONEY_REGEX = /-?\$\d+\.\d+/
    WATERMARK = "TDST"

    def extract(input_file, output_file)

    end

    def transaction_line?(line)
      line.match?(DATE_REGEX) && line.match?(MONEY_REGEX)
    end

    def extract_data_from_line(line)

    end

  end
end
