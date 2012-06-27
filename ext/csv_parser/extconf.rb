#!/usr/bin/ruby -w

require 'mkmf'

if RUBY_VERSION =~ /1.8/ then
  $CPPFLAGS += " -DRUBY_18"
end

create_makefile('csv_parser')
