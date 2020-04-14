require "spec_helper"

RSpec.describe TdStatementExtractor do
  describe ".data_from_line" do
    it "returns correct data from a clean transaction line" do
      clean_line = "NOV 20       NOV 22     WM CANADA WATERLOO                              $54.62"
      expect(TdStatementExtractor.data_from_line(clean_line)).to eq(date: "NOV 20", description: "WM CANADA WATERLOO", amount: "$54.62")
    end

    it "returns correct data from a clean transaction line with negative amount" do
      clean_line = "DEC 2        DEC 3      PAYMENT - THANK YOU                            -$827.69"
      expect(TdStatementExtractor.data_from_line(clean_line)).to eq(date: "DEC 2", description: "PAYMENT - THANK YOU", amount: "-$827.69")
    end

    it "returns correct data from a transaction line with leading spaces" do
      dirty_line = "        DEC 6       DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $665.92"
      expect(TdStatementExtractor.data_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: "$665.92")
    end

    it "returns correct data from a transaction line with trailing garbage" do
      dirty_line = "NOV 25       NOV 26     BELL CANADA (OB) MONTREAL                       $76.78         TDSTM21000_7643586_007"
      expect(TdStatementExtractor.data_from_line(dirty_line)).to eq(date: "NOV 25", description: "BELL CANADA (OB) MONTREAL", amount: "$76.78")
    end

    it "returns correct data from a transaction line with leading garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $652.53"
      expect(TdStatementExtractor.data_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: "$652.53")
    end

    it "returns correct data from a leading spaces, leading and trailing garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $652.53TDST"
      expect(TdStatementExtractor.data_from_line(dirty_line)).to eq(date: "DEC 6", description: "SHOPIFY-CHARGE.COM OTTAWA", amount: "$652.53")
    end

    it "raises an error when the transaction line does not have a valid date" do
      error_line = "TDSTM210DE_7643586_0      SHOPIFY-CHARGE.COM OTTAWA                     $652.53TDST"
      expect { TdStatementExtractor.data_from_line(error_line) }.to raise_error(RuntimeError)
    end

    it "raises an error when the transaction line does not have a valid amount" do
      error_line = "TDSTM210DE_7643586_0DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     TDST"
      expect { TdStatementExtractor.data_from_line(error_line) }.to raise_error(RuntimeError)
    end

    it "raises an error when the transaction line does not have a description" do
      error_line = "TDSTM210DE_7643586_0DEC 6                                                    $652.53TDST"
      expect { TdStatementExtractor.data_from_line(error_line) }.to raise_error(RuntimeError)
    end

  end
end
