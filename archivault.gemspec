# frozen_string_literal: true

require_relative "lib/archivault/version"

Gem::Specification.new do |spec|
  spec.name = "archivault"
  spec.version = Archivault::VERSION
  spec.authors = ["Piotr Macuk"]
  spec.email = ["piotr@macuk.pl"]

  spec.summary = "Rails backup gem for compressing, encrypting, and uploading data to AWS S3."
  spec.description = "ArchiVault is a Ruby gem for Rails applications that backs up files, logs, and databases " \
                     "using paths and credentials provided by the app. It compresses and encrypts the data, " \
                     "then uploads it securely to AWS S3."
  spec.homepage = "https://github.com/macuk/archivault"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/macuk/archivault"
  spec.metadata["changelog_uri"] = "https://github.com/macuk/archivault/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-s3", "~> 1.219"
  spec.add_dependency "rexml", "~> 3.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
