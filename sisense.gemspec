lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sisense/version"

Gem::Specification.new do |spec|
  spec.name = "sisense"
  spec.version = Sisense::VERSION
  spec.authors = ["Olivier Buffon"]
  spec.email = ["developers@chronogolf.ca"]

  spec.summary = "Sisense Ruby API Client"
  spec.description = "Light API client to communicate with Sisense API"
  spec.license = "MIT"

  spec.homepage = 'https://github.com/chronogolf/sisense'
  spec.metadata = {
    'changelog_uri' => 'https://github.com/chronogolf/sisense/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/chronogolf/sisense/',
    'bug_tracker_uri' => 'https://github.com/chronogolf/sisense/issues',
  }
  
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
