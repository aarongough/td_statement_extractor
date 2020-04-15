require "spec_helper"

VISA_2014 = File.join(RSPEC_ROOT, "fixtures", "VISA_2014.pdf")
VISA_2015 = File.join(RSPEC_ROOT, "fixtures", "VISA_2015.pdf")
VISA_2016 = File.join(RSPEC_ROOT, "fixtures", "VISA_2016.pdf")
VISA_2017 = File.join(RSPEC_ROOT, "fixtures", "VISA_2017.pdf")
VISA_2018 = File.join(RSPEC_ROOT, "fixtures", "VISA_2018.pdf")
VISA_2019 = File.join(RSPEC_ROOT, "fixtures", "VISA_2019.pdf")

RSpec.describe TdStatementExtractor::Statement do
  describe ".initialize" do
    it "checks that ghostscript is installed" do
      expect(described_class).to receive(:`).and_return("/usr/local/bin/gs")
      described_class.new(VISA_2014)
    end

    it "raises an error when ghostscript is not installed" do
      expect(described_class).to receive(:`).with('which gs').and_return("")
      expect {
        described_class.new(VISA_2014)
      }.to raise_error(described_class::GhostscriptNotInstalledError)
    end
  end

  describe "#process!" do
    it "returns correct data from a known PDF dated 2014" do
      statement = described_class.new(VISA_2014)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(21)
      expect(statement.transactions.first).to eq(date: Date.parse("JUL 15 2014"), amount: -211.00, description: "PAYMENT - THANK YOU")
    end

    it "returns correct data from a known PDF dated 2015" do
      statement = described_class.new(VISA_2015)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(34)
      expect(statement.transactions.first).to eq(date: Date.parse("APR 13 2015"), amount: 47.94, description: "JUST EAT TORONTO")
    end

    it "returns correct data from a known PDF dated 2016" do
      statement = described_class.new(VISA_2016)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(33)
      expect(statement.transactions.first).to eq(date: Date.parse("JUL 15 2016"), amount: 13.30, description: "Uber BV help.uber.co")
    end

    it "returns correct data from a known PDF dated 2017" do
      statement = described_class.new(VISA_2017)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(33)
      expect(statement.transactions.first).to eq(date: Date.parse("SEP 14 2017"), amount: 20.00, description: "PRESTO TORONTO")
    end

    it "returns correct data from a known PDF dated 2018" do
      statement = described_class.new(VISA_2018)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(24)
      expect(statement.transactions.first).to eq(date: Date.parse("JUL 15 2018"), amount: 54.76, description: "CASA SUSHI TORONTO")
    end

    it "returns correct data from a known PDF dated 2019" do
      statement = described_class.new(VISA_2019)

      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions.length).to be(48)
      expect(statement.transactions.first).to eq(date: Date.parse("NOV 15 2019"), amount: 1.67, description: "SHOPIFY-CHARGE.COM OTTAWA")
    end
  end

  describe "#transaction_line?" do
    subject { described_class.new(VISA_2014) }

    it "returns true when given a clean transaction line" do
      clean_line = "DEC 2  DEC 3  PAYMENT - THANK YOU    -$827.69"
      expect(subject.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a clean transaction line with commas in amount" do
      clean_line = "DEC 2  DEC 3  PAYMENT - THANK YOU    $8,270.69"
      expect(subject.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a clean payment transaction line with commas in amount" do
      clean_line = "DEC 3  DEC 4  PAYMENT - THANK YOU    -$3,306.61"
      expect(subject.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a transaction line with leading spaces" do
      dirty_line = "  DEC 6  DEC 6  SHOPIFY-CHARGE.COM OTTAWA    $665.92"
      expect(subject.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with trailing garbage" do
      dirty_line = "DEC 3  DEC 5  GOOGLE*GOOGLE MUSIC INTERNET    $9.99TDST"
      expect(subject.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with leading garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6  SHOPIFY-CHARGE.COM OTTAWA    $652.53"
      expect(subject.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with leading garbage, trailing garbage, and leading spaces" do
      dirty_line = "  TDSTM210DE_7643586_0DEC 6  SHOPIFY-CHARGE.COM OTTAWA    $652.53TDST"
      expect(subject.transaction_line?(dirty_line)).to be true
    end

    it "returns false when given a blank line" do
      non_transaction = "            "
      expect(subject.transaction_line?(non_transaction)).to be false
    end

    it "returns false when given a non-transaction line" do
      non_transaction = "   FOREIGN CURRENCY 492.01 USD"
      expect(subject.transaction_line?(non_transaction)).to be false
    end

    it "returns false when given a legalese line" do
      non_transaction = "Foreign Currency Conversion: Foreign currency will be converted"
      expect(subject.transaction_line?(non_transaction)).to be false
    end
  end

  describe "#transaction_from_line" do
    subject { described_class.new(VISA_2014) }

    it "returns correct data from a clean transaction line" do
      clean_line = "NOV 20  NOV 22  WM CANADA WATERLOO    $54.62"
      expect(subject.transaction_from_line(clean_line)).to eq(date: "NOV 20", description: "WM CANADA WATERLOO", amount: 54.62)
    end

    it "returns correct data from a clean transaction line with negative amount" do
      clean_line = "DEC 2  DEC 3  PAYMENT - THANK YOU    -$827.69"
      expect(subject.transaction_from_line(clean_line)).to eq(date: "DEC 2", description: "PAYMENT - THANK YOU", amount: -827.69)
    end

    it "returns correct data from a transaction line with leading spaces" do
      dirty_line = "  DEC 6  DEC 6  SHOPIFY-CHARGE.COM OTTAWA    $665.92"
      expect(subject.transaction_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: 665.92)
    end

    it "returns correct data from a transaction line with trailing garbage" do
      dirty_line = "NOV 25  NOV 26  BELL CANADA (OB) MONTREAL    $76.78    TDSTM21000_7643586_007"
      expect(subject.transaction_from_line(dirty_line)).to eq(date: "NOV 25", description: "BELL CANADA (OB) MONTREAL", amount: 76.78)
    end

    it "returns correct data from a transaction line with leading garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6  SHOPIFY-CHARGE.COM OTTAWA     $652.53"
      expect(subject.transaction_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: 652.53)
    end

    it "returns correct data from a leading spaces, leading and trailing garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6  SHOPIFY-CHARGE.COM OTTAWA    $652.53TDST"
      expect(subject.transaction_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: 652.53)
    end

    it "raises an error when the transaction line does not have a valid date" do
      error_line = "TDSTM210DE_7643586_0  SHOPIFY-CHARGE.COM OTTAWA    $652.53TDST"
      expect { subject.transaction_from_line(error_line) }.to raise_error(described_class::MissingDateError)
    end

    it "raises an error when the transaction line does not have a valid amount" do
      error_line = "TDSTM210DE_7643586_0DEC 6  SHOPIFY-CHARGE.COM OTTAWA    TDST"
      expect { subject.transaction_from_line(error_line) }.to raise_error(described_class::MissingAmountError)
    end

    it "raises an error when the transaction line does not have a description" do
      error_line = "TDSTM210DE_7643586_0DEC 6                         $652.53TDST"
      expect { subject.transaction_from_line(error_line) }.to raise_error(described_class::MissingDescriptionError)
    end
  end

  describe "#transform_date" do
    subject { described_class.new(VISA_2014) }

    it "returns a date with the correct format" do
      date = subject.transform_date("NOV 15", "December 16, 2019")
      expect(date).to eq(Date.parse("Nov 15 2019"))
    end

    it "returns the correct date when crossing a year boundary" do
      date = subject.transform_date("DEC 15", "January 16, 2020")
      expect(date).to eq(Date.parse("Dec 15 2019"))
    end

    it "returns the correct date when at start of new year" do
      date = subject.transform_date("JAN 1", "January 16, 2020")
      expect(date).to eq(Date.parse("Jan 1 2020"))
    end

    it "raises an error when given a garbage month" do
      expect {
        subject.transform_date("DOC 15", "January 16, 2020")
      }.to raise_error(described_class::InvalidMonthError)
    end

    it "raises an error when given a garbage day" do
      expect {
        subject.transform_date("DEC 99", "January 16, 2020")
      }.to raise_error(described_class::InvalidDayError)
    end

    it "raises an error when given a garbage described_class date" do
      expect {
        subject.transform_date("DEC 15", "foo")
      }.to raise_error(described_class::InvalidStatementDateError)
    end

    it "raises an error when given a garbage described_class date" do
      expect {
        subject.transform_date("DEC 15", "99")
      }.to raise_error(described_class::InvalidStatementDateError)
    end
  end
end
