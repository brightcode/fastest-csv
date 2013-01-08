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
