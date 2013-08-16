# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fastest-csv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maarten Oelering"]
  gem.email         = ["maarten@brightcode.nl"]
  gem.description   = %q{Fastest standard CSV parser for MRI Ruby and JRuby}
  gem.summary       = %q{Fastest standard CSV parser for MRI Ruby and JRuby}
  gem.homepage      = "https://github.com/brightcode/fastest-csv"

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fastest-csv"
  gem.require_paths = ["lib"]
  gem.version       = FastestCSV::VERSION

  if RUBY_PLATFORM =~ /java/
    gem.platform = "java"
    gem.files << "lib/csv_parser.jar"
  else
    gem.extensions  = ['ext/csv_parser/extconf.rb']
  end
  
  gem.add_development_dependency "rake-compiler"
  
  gem.license = 'MIT'
end
