# -*- encoding: utf-8 -*-
# stub: dropbox-sdk 1.6.5 ruby lib

Gem::Specification.new do |s|
  s.name = "dropbox-sdk".freeze
  s.version = "1.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dropbox, Inc.".freeze]
  s.date = "2015-07-29"
  s.description = "    A library that provides a plain function-call interface to the\n    Dropbox API web endpoints.\n".freeze
  s.email = ["support-api@dropbox.com".freeze]
  s.homepage = "http://www.dropbox.com/developers/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Dropbox REST API Client.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 4.3.2"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
    else
      s.add_dependency(%q<json>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 4.3.2"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 4.3.2"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
  end
end
