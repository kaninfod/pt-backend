# -*- encoding: utf-8 -*-
# stub: resque-loner 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "resque-loner".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jannis Hermanns".freeze]
  s.date = "2014-03-24"
  s.description = "Makes sure that for special jobs, there can be only one job with the same\nworkload in one queue.\n\nExample:\n    class CacheSweeper\n       include Resque::Plugins::UniqueJob\n\n       @queue = :cache_sweeps\n\n       def self.perform(article_id)\n         # Cache Me If You Can...\n       end\n    end\n".freeze
  s.email = ["jannis@moviepilot.com".freeze]
  s.homepage = "http://github.com/jayniz/resque-loner".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "resque-loner".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Adds unique jobs to resque".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<resque>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<airbrake>.freeze, [">= 0"])
      s.add_development_dependency(%q<i18n>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<mock_redis>.freeze, [">= 0"])
      s.add_development_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>.freeze, [">= 0"])
    else
      s.add_dependency(%q<resque>.freeze, ["~> 1.0"])
      s.add_dependency(%q<airbrake>.freeze, [">= 0"])
      s.add_dependency(%q<i18n>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<mock_redis>.freeze, [">= 0"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<yajl-ruby>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<resque>.freeze, ["~> 1.0"])
    s.add_dependency(%q<airbrake>.freeze, [">= 0"])
    s.add_dependency(%q<i18n>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<mock_redis>.freeze, [">= 0"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<yajl-ruby>.freeze, [">= 0"])
  end
end
