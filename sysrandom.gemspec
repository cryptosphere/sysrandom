Gem::Specification.new do |spec|
  spec.name          = "sysrandom"
  spec.version       = "0.0.1"
  spec.authors       = ["Tony Arcieri"]
  spec.email         = ["bascule@gmail.com"]

  spec.summary       = "Secure random number generation using system RNG facilities"
  spec.description   = "Sysrandom generates secure random numbers using /dev/urandom, getrandom(), etc"
  spec.homepage      = "https://github.com/cryptosphere/sysrandom"
  spec.licenses      = ["ISC"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extensions = ["ext/sysrandom/extconf.rb"]
end
