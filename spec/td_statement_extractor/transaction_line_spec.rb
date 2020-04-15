require "spec_helper"

RSpec.describe TdStatementExtractor do
  describe ".transaction_line?" do
    it "returns true when given a clean transaction line" do
      clean_line = "DEC 2        DEC 3      PAYMENT - THANK YOU                            -$827.69"
      expect(TdStatementExtractor.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a clean transaction line with commas in amount" do
      clean_line = "DEC 2        DEC 3      PAYMENT - THANK YOU                            $8,270.69"
      expect(TdStatementExtractor.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a clean payment transaction line with commas in amount" do
      clean_line = "DEC 3        DEC 4      PAYMENT - THANK YOU                          -$3,306.61"
      expect(TdStatementExtractor.transaction_line?(clean_line)).to be true
    end

    it "returns true when given a transaction line with leading spaces" do
      dirty_line = "        DEC 6       DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $665.92"
      expect(TdStatementExtractor.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with trailing garbage" do
      dirty_line = "DEC 3       DEC 5      GOOGLE*GOOGLE MUSIC INTERNET                    $9.99TDST"
      expect(TdStatementExtractor.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with leading garbage" do
      dirty_line = "TDSTM210DE_7643586_0DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $652.53"
      expect(TdStatementExtractor.transaction_line?(dirty_line)).to be true
    end

    it "returns true when given a transaction line with leading garbage, trailing garbage, and leading spaces" do
      dirty_line = "   TDSTM210DE_7643586_0DEC 6      SHOPIFY-CHARGE.COM OTTAWA                     $652.53TDST"
      expect(TdStatementExtractor.transaction_line?(dirty_line)).to be true
    end

    it "returns false when given a blank line" do
      non_transaction = "            "
      expect(TdStatementExtractor.transaction_line?(non_transaction)).to be false
    end

    it "returns false when given a non-transaction line" do
      non_transaction = "                               FOREIGN CURRENCY 492.01 USD"
      expect(TdStatementExtractor.transaction_line?(non_transaction)).to be false
    end

    it "returns false when given a legalese line" do
      non_transaction = "Foreign Currency Conversion: Foreign currency will be converted by applying a rate established by VISA plus 2.5% as described"
      expect(TdStatementExtractor.transaction_line?(non_transaction)).to be false
    end
  end
end
