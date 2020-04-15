require "spec_helper"

RSpec.describe TdStatementExtractor do
  describe ".extract" do
    it "returns correct data from a known PDF" do
      clean_line = "NOV 20       NOV 22     WM CANADA WATERLOO                              $54.62"
      expect(TdStatementExtractor.data_from_line(clean_line)).to eq(date: "NOV 20", description: "WM CANADA WATERLOO", amount: "$54.62")
    end
  end
end
