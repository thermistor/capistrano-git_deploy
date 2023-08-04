# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-git_deploy"
  gem.version       = '0.1.0'
  gem.authors       = ["Weston Triemstra"]
  gem.email         = ["weston@netsign.com"]
  gem.description   = %q{Capistrano deploys with git}
  gem.summary       = %q{Capistrano deploys with git}
  gem.homepage      = "https://github.com/thermistor/capistrano-git_deploy"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 3.11.0'
end
