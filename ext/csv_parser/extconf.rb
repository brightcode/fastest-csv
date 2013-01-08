#!/usr/bin/ruby -w

require 'mkmf'
extension_name = 'csv_parser'
#dir_config(extension_name)

if RUBY_VERSION =~ /1.8/ then
  $CPPFLAGS += " -DRUBY_18"
end

#if CONFIG["arch"] =~ /mswin32|mingw/
#  $CFLAGS += " -march=i686"
#end

create_makefile(extension_name)
