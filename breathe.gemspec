lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "breathe/version"

Gem::Specification.new do |spec|
  spec.name = "breathe"
  spec.version = Breathe::VERSION
  spec.authors = ["Stuart Harrison"]
  spec.email = ["pezholio@gmail.com"]

  spec.summary = "A Ruby Wrapper for the BreateHR API"
  spec.homepage = "http://github.com/dxw/breathe_ruby"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/dxw/breathe_ruby"
  spec.metadata["changelog_uri"] = "http://github.com/dxw/breathe_ruby/blob/master/Changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 0.1.5"
  spec.add_development_dependency "dotenv", "~> 2.8.1"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "webmock", "~> 3.15.0"

  spec.add_dependency "sawyer", ">= 0.8.2", "< 0.10.0"
end
