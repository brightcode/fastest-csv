package org.brightcode;

import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyFixnum;
import org.jruby.RubyModule;
import org.jruby.RubyObject;
import org.jruby.RubyString;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.CallbackFactory;
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

        RubyModule mCsvParser = runtime.defineModule("CsvParser");
        CallbackFactory callbackFactory = runtime.callbackFactory(CsvParserService.class);  // MethodFactory?
        // fast? public?
        mCsvParser.defineModuleFunction("parse_line", 
            callbackFactory.getSingletonMethod("parseLine", RubyString.class));
        return true;
    }
    
    public static IRubyObject parseLine(IRubyObject recv, RubyString line) {
        // The recv parameter is the instance of RubyModule/RubyClass that the method is called on.
        RubyArray array = RubyArray.newArray(recv.getRuntime(), 36);
        // TODO ...
        return array;
    }
}
