# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "activestorage_saas"
  spec.version = "7.1.1"
  spec.authors = ["xiaohui"]
  spec.email = ["xiaohui@tanmer.com"]

  spec.summary = "Wraps multi-tenant storage services as ActiveStorage service"
  spec.description = "Each tenant can set its own storage service, ActiveStorage service can be dynamically loaded."
  spec.homepage = "https://github.com/xiaohui-zhangxh/activestorage_saas"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = [
    'Gemfile',
    'lib/**/*'
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "activestorage", '>=7.0.3.1', '< 7.2'
end
