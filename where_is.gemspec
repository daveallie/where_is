# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'where_is/version'

Gem::Specification.new do |spec|
  spec.name          = 'where_is'
  spec.version       = Where::VERSION
  spec.authors       = ['Dave Allie']
  spec.email         = ['dave@daveallie.com']

  spec.summary       = 'A little Ruby gem for finding the source location' \
                       ' where class and methods are defined.'
  spec.description   = 'A little Ruby gem for finding the source location' \
                       ' where class and methods are defined.'
  spec.homepage      = 'https://github.com/daveallie/where_is'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'] + %w[CODE_OF_CONDUCT.md LICENSE.txt
                                            README.md Gemfile where_is.gemspec]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.1'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '>= 3.9'
  spec.add_development_dependency 'rubocop', '>= 0.80'
end
