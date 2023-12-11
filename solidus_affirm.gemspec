# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_affirm/version'

Gem::Specification.new do |s|
  s.name = 'solidus_affirm'
  s.version = SolidusAffirm::VERSION
  s.summary = 'Solidus extension for using Affirm in your store'
  s.license = 'BSD-3-Clause'

  s.author = 'Peter Berkenbosch'
  s.email = 'peter@stembolt.com'
  s.homepage = 'https://github.com/solidusio/solidus_affirm'

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.required_ruby_version = ['>= 2.4', '< 4.0']

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'active_model_serializers', '~> 0.10'
  s.add_dependency 'affirm-ruby', '~> 1.1.0'
  s.add_dependency 'solidus_core', ['>= 1.4.0', '< 5']
  s.add_dependency "solidus_support", ['>= 0.4.1', '< 1']

  s.add_development_dependency 'solidus_dev_support'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
