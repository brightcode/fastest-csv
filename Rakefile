#!/usr/bin/env rake
require "bundler/gem_tasks"

spec = Gem::Specification.load('fastest-csv.gemspec')

if RUBY_PLATFORM =~ /java/
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new('csv_parser', spec)
else
  require 'rake/extensiontask'
  Rake::ExtensionTask.new('csv_parser', spec)
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/tc_*.rb']
  #test.libs << 'lib' << 'test'
  #test.pattern = 'test/**/test_*.rb'
  #test.verbose = true
end

