# -*- encoding: utf-8; mode: ruby -*-
require File.expand_path('../lib/berkshelf/hobo/version', __FILE__)

Gem::Specification.new do |s|
  s.authors               = [
    "Jamie Winsor",
    "Josiah Kiehl",
    "Michael Ivey",
    "Justin Campbell"
  ]
  s.email                 = [
    "reset@riotgames.com",
    "jkiehl@riotgames.com",
    "michael.ivey@riotgames.com",
    "justin.campbell@riotgames.com"
  ]

  s.description           = %q{Use Berkshelf with Vagrant 1.0}
  s.summary               = s.description
  s.homepage              = "http://berkshelf.com"
  s.license               = "Apache 2.0"
  s.files                 = `git ls-files`.split($\)
  s.executables           = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files            = s.files.grep(%r{^(test|spec|features)/})
  s.name                  = "berkshelf-hobo"
  s.require_paths         = ["lib"]
  s.version               = Berkshelf::Hobo::VERSION
  s.required_ruby_version = ">= 1.9.1"

  s.add_dependency 'berkshelf', '~> 1.3.1'
  s.add_dependency 'vagrant', '~> 1.0.7'

end
