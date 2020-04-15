require "spec_helper"

RSpec.describe TdStatementExtractor do
  describe "VERSION" do
    it "has a version number" do
      expect(TdStatementExtractor::VERSION).not_to be nil
    end
  end
end
