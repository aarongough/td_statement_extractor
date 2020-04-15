require "spec_helper"

ENCRYPTED_PDF = File.join(RSPEC_ROOT, "fixtures", "ENCRYPTED_VISA_CARD_2019.pdf")

RSpec.describe TdStatementExtractor do
  describe ".pre_process_pdf" do
    it "checks that ghostscript is installed" do
      expect(described_class).to receive(:`).and_return("/usr/local/bin/gs")
      expect(described_class).to receive(:`).and_return("/usr/local/bin/gs")
      TdStatementExtractor.pre_process_pdf(ENCRYPTED_PDF)
    end

    it "raises an error when ghostscript is not installed" do
      expect(described_class).to receive(:`).with('which gs').and_return("")
      expect {
        TdStatementExtractor.pre_process_pdf(ENCRYPTED_PDF)
      }.to raise_error(TdStatementExtractor::GhostscriptNotInstalledError)
    end

    it "returns a file path to the processed PDF" do
      file_path = TdStatementExtractor.pre_process_pdf(ENCRYPTED_PDF)
      expect(File.file?(file_path)).to be true
      File.delete(file_path)
    end
  end
end
