# -*- encoding: utf-8 -*-
# stub: phashion 1.2.0 ruby lib
# stub: ext/phashion_ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "phashion".freeze
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mike Perham".freeze]
  s.date = "2014-10-29"
  s.description = "Simple wrapper around the pHash library".freeze
  s.email = ["mperham@gmail.com".freeze]
  s.extensions = ["ext/phashion_ext/extconf.rb".freeze]
  s.files = ["ext/phashion_ext/extconf.rb".freeze]
  s.homepage = "http://github.com/westonplatter/phashion".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Simple wrapper around the pHash library".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0.7.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.2.2"])
    else
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0.7.0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.2.2"])
    end
  else
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0.7.0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.2.2"])
  end
end
