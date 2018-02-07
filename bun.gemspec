lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bun/version"

Gem::Specification.new do |spec|
  spec.name          = "bun"
  spec.version       = Bun::VERSION
  spec.authors       = ["Hrvoje Šimić"]
  spec.email         = ["shime@twobucks.co"]

  spec.summary       = %q{CLI tool to install and remove gems from Gemfile with ease.}
  spec.homepage      = "https://github.com/shime/bun"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "tty-spinner", "~> 0.8.0"
  spec.add_runtime_dependency "paint", "~> 2.0.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7.0"
  spec.add_development_dependency "pry", "~> 0.11.3"
end
