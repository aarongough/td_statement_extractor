require "spec_helper"

DECRYPTED_PDF_2019 = File.join(RSPEC_ROOT, "fixtures", "DECRYPTED_VISA_CARD_2019.pdf")

RSpec.describe TdStatementExtractor do
  describe ".extract_data_from_pdf" do
    it "returns correct data from a known decrypted PDF dated 2019" do
      data = TdStatementExtractor.extract_data_from_pdf(DECRYPTED_PDF_2019)

      expect(data).to be_a(Array)
      expect(data.length).to be(48)
      expect(data.first).to eq(date: "NOV 15", amount: "$1.02", description: "SHOPIFY-CHARGE.COM OTTAWA")
    end
  end
end
