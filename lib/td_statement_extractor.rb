require "td_statement_extractor/version"
require "pdf-reader"

class TdStatementExtractor
  class << self

    DATE1_REGEX = /(?<date1>(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s[0-9]+)/
    DATE2_REGEX = /(?<date2>(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s[0-9]+)/
    AMOUNT_REGEX = /(?<amount>-?\$[,\d]+\.\d+)/
    DESCRIPTION_REGEX = /#{DATE1_REGEX}\s+#{DATE2_REGEX}?\s+(?<description>.+)\s+#{AMOUNT_REGEX}/

    def extract_data_from_pdf(input_file_path)
      pdf = PDF::Reader.new(input_file_path)
      text = pdf.pages.map {|page| page.text }.join

      text.each_line.map do |line|
        next unless transaction_line?(line)
        data_from_line(line)
      end.compact
    end

    def transaction_line?(line)
      line.match?(DATE1_REGEX) && line.match?(AMOUNT_REGEX)
    end

    def data_from_line(line)
      date = line.match(DATE1_REGEX)&.[](:date1)
      amount = line.match(AMOUNT_REGEX)&.[](:amount)
      description = line.match(DESCRIPTION_REGEX)&.[](:description)&.strip

      raise MissingDateError, "Error extracting DATE from line: #{line}" if date.nil? || date.empty?
      raise MissingAmountError, "Error extracting AMOUNT from line: #{line}" if amount.nil? || amount.empty?
      raise MissingDescriptionError, "Error extracting DESCRIPTION from line: #{line}" if description.nil? || description.empty?

      { date: date, description: description, amount: amount }
    end
  end

  class MissingDateError < StandardError; end
  class MissingAmountError < StandardError; end
  class MissingDescriptionError < StandardError; end
end
