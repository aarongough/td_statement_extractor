require "pdf-reader"
require "date"
require "csv"

module TdStatementExtractor
  class Statement
    STATEMENT_DATE = /(?<statement_date>(?<month>[A-Z][a-z]+)\s(?<day>[0-9]+),\s(?<year>[0-9]{4}))/
    MONTH = /(?<month>JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)/
    DAY = /(?<day>[0-9]+)/
    DATE = /(?<date>#{MONTH}\s#{DAY})/
    AMOUNT = /(?<amount>-?\$[,\d]+\.\d+)/
    DESCRIPTION = /#{DATE}\s+#{DATE}?\s+(?<description>.+)\s+#{AMOUNT}/

    attr_accessor :input_file_path, :temp_file_path, :debug_mode, :transactions, :statement_date, :pdf, :text

    def initialize(input_file_path, debug_mode = false)
      @input_file_path = input_file_path
      @debug_mode = debug_mode

      self.class.check_for_ghostscript
  
      pre_process_pdf
      import_pdf
      extract_statement_date
      
      @transactions = text.each_line.map do |line|
        puts "#{transaction_line?(line) ? 'T' : 'F'} - #{line.lstrip.strip}" if @debug_mode && line.match?(/\w+/)
        next unless transaction_line?(line)
        data = transaction_from_line(line)
        data[:date] = transform_date(data[:date], statement_date)

        data
      end.compact
    ensure
      File.delete(temp_file_path) unless temp_file_path.nil?
    end

    def pre_process_pdf
      @temp_file_path = File.join(File.dirname(@input_file_path), "td_statement_temp_#{Time.now.to_i}.pdf")

      # Use Ghostscript to decrypt and decompress the PDF. Also remove
      # all images and crop the margins to remove watermarking that interferes
      # with the scraping process
      `gs -o #{@temp_file_path} -sDEVICE=pdfwrite -dFILTERVECTOR -dFILTERIMAGE -g5400x7200 -c "<</PageOffset [-36 -36]>> setpagedevice" -f #{@input_file_path}` 
    end

    def import_pdf
      @pdf = PDF::Reader.new(temp_file_path)
      @text = pdf.pages.map {|page| page.text }.join
    end

    def extract_statement_date
      @statement_date = text.match(STATEMENT_DATE)&.[](:statement_date)
      raise InvalidStatementDateError, "Unable to extract statement date" if statement_date.nil? || statement_date.empty?
    end


    def transaction_line?(line)
      line.match?(DATE) && line.match?(AMOUNT)
    end

    def transaction_from_line(line)
      date = line.match(DATE)&.[](:date)
      amount = line.match(AMOUNT)&.[](:amount)&.gsub("$", "")&.gsub(",", "")&.to_f
      description = line.match(DESCRIPTION)&.[](:description)&.strip

      raise MissingDateError, "Error extracting DATE from line: #{line}" if date.nil? || date.empty?
      raise MissingAmountError, "Error extracting AMOUNT from line: #{line}" if amount.nil? || amount.zero?
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

    def total_activity
      transactions.reduce(0) {|total, x| total + x[:amount] }.round(2)
    end

    def output_csv(output_path)
      CSV.open(output_path, "w") do |csv|
        transactions.each do |transaction|
          csv << [ transaction[:date].strftime("%d/%m/%Y"), transaction[:description], transaction[:amount] ]
        end
      end
    end

    def self.check_for_ghostscript
      raise GhostscriptNotInstalledError, "Please install Ghostscript. See docs for more info." if `which gs`.empty?
    end

    class MissingDateError < StandardError; end
    class MissingAmountError < StandardError; end
    class MissingDescriptionError < StandardError; end
    class InvalidMonthError < StandardError; end
    class InvalidDayError < StandardError; end
    class InvalidStatementDateError < StandardError; end
    class GhostscriptNotInstalledError < StandardError; end
  end
end