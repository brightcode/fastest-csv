package org.brightcode.csv;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyFixnum;
import org.jruby.RubyModule;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.BasicLibraryService;

public class CsvParserService implements BasicLibraryService {

    private Ruby runtime;
  
    // Initial setup function. Takes a reference to the current JRuby runtime and
    // sets up our modules.
    public boolean basicLoad(Ruby runtime) throws IOException {
        this.runtime = runtime;
    
        return true;
    }
}
