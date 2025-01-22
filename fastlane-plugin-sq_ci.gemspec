lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/sq_ci/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-sq_ci'
  spec.version       = Fastlane::SqCi::VERSION
  spec.author        = 'Semen Kologrivov'
  spec.email         = 'semen@sequenia.com'

  spec.summary       = 'CI Library for sequenia\'s projects'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-sq_ci"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'
  spec.add_dependency('ruby-filemagic')

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency
end
