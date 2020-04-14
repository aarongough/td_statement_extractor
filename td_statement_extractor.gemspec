
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "td_statement_extractor/version"

Gem::Specification.new do |spec|
  spec.name          = "td_statement_extractor"
  spec.version       = TdStatementExtractor::VERSION
  spec.authors       = ["Aaron Gough"]
  spec.email         = ["aaron.gough@gmail.com"]

  spec.summary       = %q{Extract machine readable transaction data from TD credit card statements.}
  spec.description   = %q{Extract machine readable transaction data from TD credit card statements.}
  spec.homepage      = "https://github.com/aarongough/td_statement_extractor"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_developmentdependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
