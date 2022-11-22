# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "activestorage_saas"
  spec.version = "7.0.4"
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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "activestorage", '>=7.0.3.1', '<= 7.0.4'
end
