# -*- encoding: utf-8 -*-
# stub: active_scheduler 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "active_scheduler".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Justin Aiken".freeze]
  s.date = "2017-01-04"
  s.description = "A wrapper for scheduling jobs through ActiveJob".freeze
  s.email = ["60tonangel@gmail.com".freeze]
  s.homepage = "https://github.com/JustinAiken/active_scheduler".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "active_scheduler".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Scheduling for ActiveJob".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activejob>.freeze, [">= 4.2.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<activejob>.freeze, [">= 4.2.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.5"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<activejob>.freeze, [">= 4.2.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
  end
end
