# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cliutils/constants'

Gem::Specification.new do |spec|
  spec.name             = "cliutils"
  spec.version          = CLIUtils::VERSION
  spec.authors          = ["Aaron Bach"]
  spec.email            = ["bachya1208@googlemail.com"]
  spec.summary          = 'Sugary goodness for Ruby CLI apps.'
  spec.description      = 'A library of functionality designed to alleviate common tasks and headaches when developing command-line (CLI) apps in Ruby.'
  spec.homepage         = "http://www.bachyaproductions.com/cliutils-ruby-library-cli-apps/"
  spec.license          = "MIT"
                        
  spec.files            = `git ls-files -z`.split("\x0")
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  spec.add_development_dependency('bundler', '~> 1.5')
  spec.add_development_dependency('pry', '~> 0.9')
  spec.add_development_dependency('rake', '~> 0')
  spec.add_development_dependency('yard', '0.8.7.4')
end
