# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'fanswatch/version'

Gem::Specification.new do |s|
  s.name        =  'fanswatch'
  s.version     =  FansWatch::VERSION

  s.summary     =  'Gets posted content from public Facebook fans pages'
  s.description =  'Extracts feed, postings, and attachments from FB fans pages'
  s.authors     =  ['Wei-Tang Lin']
  s.email       =  ['wtlin0711@gmail.com']

  s.files       =  `git ls-files`.split("\n")
  s.test_files  =  `git ls-files -- spec/*`.split("\n")
  s.executables << 'fanswatch'

  s.add_runtime_dependency 'http', '~> 2.0'

  s.add_development_dependency 'minitest', '~> 5.9'
  s.add_development_dependency 'minitest-rg', '~> 5.2'
  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 2.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'flog', '~> 4.4'
  s.add_development_dependency 'flay', '~> 2.8'
  s.add_development_dependency 'rubocop', '~> 0.42'
  s.homepage    =  'https://github.com/wtlin1228/FansWatch'
  s.license     =  'MIT'
end
