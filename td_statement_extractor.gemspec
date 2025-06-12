lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "td_statement_extractor/version"

Gem::Specification.new do |spec|
  spec.name = "td_statement_extractor"
  spec.version = TdStatementExtractor::VERSION
  spec.authors = ["Aaron Gough"]
  spec.email = ["aaron.gough@gmail.com"]

  spec.summary = "Extract machine readable transaction data from TD credit card statements."
  spec.description = <<~EOM
    Extract machine readable transaction data from TD credit card statements.
    This gem parses PDF statements from TD Canada Trust and extracts transaction data into a structured format.
    It is designed to work with the PDF format used by TD Canada Trust for their credit card statements.
  EOM
  spec.homepage = "https://github.com/aarongough/td_statement_extractor"
  spec.license = "MIT"

  spec.required_ruby_version = ">= #{File.read(".ruby-version").strip}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pdf-reader", "~> 2.4.0"
  spec.add_dependency "csv", "~> 3.3.5"

  spec.add_development_dependency "standard", "~> 1.50.0"
  spec.add_development_dependency "base64", "~> 0.3.0"
  spec.add_development_dependency "bundler", "~> 2.4.5"
  spec.add_development_dependency "rake", "~> 13.3.0"
  spec.add_development_dependency "rspec", "~> 3.13.1"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
end
