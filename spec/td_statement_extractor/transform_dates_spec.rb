require "spec_helper"

RSpec.describe TdStatementExtractor do
  describe ".transform_date" do
    it "returns a date with the correct format" do
      date = TdStatementExtractor.transform_date("NOV 15", "December 16, 2019")
      expect(date).to eq(Date.parse("Nov 15 2019"))
    end

    it "returns the correct date when crossing a year boundary" do
      date = TdStatementExtractor.transform_date("DEC 15", "January 16, 2020")
      expect(date).to eq(Date.parse("Dec 15 2019"))
    end

    it "returns the correct date when at start of new year" do
      date = TdStatementExtractor.transform_date("JAN 1", "January 16, 2020")
      expect(date).to eq(Date.parse("Jan 1 2020"))
    end

    it "raises an error when given a garbage month" do
      expect {
        TdStatementExtractor.transform_date("DOC 15", "January 16, 2020")
      }.to raise_error(TdStatementExtractor::InvalidMonthError)
    end

    it "raises an error when given a garbage day" do
      expect {
        TdStatementExtractor.transform_date("DEC 99", "January 16, 2020")
      }.to raise_error(TdStatementExtractor::InvalidDayError)
    end

    it "raises an error when given a garbage statement date" do
      expect {
        TdStatementExtractor.transform_date("DEC 15", "foo")
      }.to raise_error(TdStatementExtractor::InvalidStatementDateError)
    end

    it "raises an error when given a garbage statement date" do
      expect {
        TdStatementExtractor.transform_date("DEC 15", "99")
      }.to raise_error(TdStatementExtractor::InvalidStatementDateError)
    end
  end
end
