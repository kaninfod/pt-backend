# -*- encoding: utf-8 -*-
# stub: ruby-filemagic 0.7.1 ruby lib
# stub: ext/filemagic/extconf.rb

Gem::Specification.new do |s|
  s.name = "ruby-filemagic".freeze
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Travis Whitton".freeze, "Jens Wille".freeze]
  s.date = "2015-10-27"
  s.description = "Ruby bindings to the magic(4) library".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.extensions = ["ext/filemagic/extconf.rb".freeze]
  s.extra_rdoc_files = ["README".freeze, "ChangeLog".freeze, "ext/filemagic/filemagic.c".freeze]
  s.files = ["ChangeLog".freeze, "README".freeze, "ext/filemagic/extconf.rb".freeze, "ext/filemagic/filemagic.c".freeze]
  s.homepage = "http://github.com/blackwinter/ruby-filemagic".freeze
  s.licenses = ["Ruby".freeze]
  s.post_install_message = "\nruby-filemagic-0.7.1 [2015-10-27]:\n\n* List default lib and header directories (pull request #18 by Adam Wr\u00F3bel).\n\n".freeze
  s.rdoc_options = ["--title".freeze, "ruby-filemagic Application documentation (v0.7.1)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Ruby bindings to the magic(4) library".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
    else
      s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
  end
end
