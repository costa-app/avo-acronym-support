# frozen_string_literal: true

require_relative "lib/avo/acronym/support/version"

Gem::Specification.new do |spec|
  spec.name = "avo-acronym-support"
  spec.version = Avo::Acronym::Support::VERSION
  spec.authors = ["hmk"]
  spec.email = ["hmk@users.noreply.github.com"]

  spec.summary       = "Compatibility patches for Avo under custom ActiveSupport acronyms."
  spec.files         = Dir["lib/**/*", "README.md"].select { |f| File.file?(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1"
  spec.add_dependency "avo", ">= 3.0"
end
