# -*- encoding: utf-8 -*-
# stub: mini_exiftool 2.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mini_exiftool".freeze
  s.version = "2.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Friedrich".freeze]
  s.date = "2016-09-12"
  s.description = "This library is a wrapper for the ExifTool command-line application\n(http://www.sno.phy.queensu.ca/~phil/exiftool) written by Phil Harvey.\nIt provides the full power of ExifTool to Ruby: reading and writing of\nEXIF-data, IPTC-data and XMP-data.\n".freeze
  s.email = "janfri26@gmail.com".freeze
  s.homepage = "https://github.com/janfri/mini_exiftool".freeze
  s.licenses = ["LGPL-2.1".freeze]
  s.post_install_message = "+-----------------------------------------------------------------------+\n| Please ensure you have installed exiftool at least version 7.65       |\n| and it's found in your PATH (Try \"exiftool -ver\" on your commandline).|\n| For more details see                                                  |\n| http://www.sno.phy.queensu.ca/~phil/exiftool/install.html             |\n| You need also Ruby 1.9 or higher.                                     |\n| If you need support for Ruby 1.8 or exiftool prior 7.65 install       |\n| mini_exiftool version < 2.0.0.                                        |\n+-----------------------------------------------------------------------+\n".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "This library is a wrapper for the ExifTool command-line application (http://www.sno.phy.queensu.ca/~phil/exiftool).".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rim>.freeze, ["~> 2.9"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<regtest>.freeze, [">= 0"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rim>.freeze, ["~> 2.9"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<regtest>.freeze, [">= 0"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rim>.freeze, ["~> 2.9"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<regtest>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
  end
end
