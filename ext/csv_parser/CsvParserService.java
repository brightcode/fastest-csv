//
// Copyright (c) Maarten Oelering, BrightCode BV
//

package org.brightcode;

import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyModule;
import org.jruby.RubyString;
import org.jruby.runtime.Block;
import org.jruby.runtime.CallbackFactory;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.BasicLibraryService;

public class CsvParserService implements BasicLibraryService {

    private Ruby runtime;

    private static int DEF_ARRAY_LEN = 32;

    private static int UNQUOTED = 0;
    private static int IN_QUOTED = 1;
    private static int QUOTE_IN_QUOTED = 2;
    
    // Initial setup function. Takes a reference to the current JRuby runtime and
    // sets up our modules.
    public boolean basicLoad(Ruby runtime) throws IOException {
        this.runtime = runtime;

        RubyModule mCsvParser = runtime.defineModule("CsvParser");
        CallbackFactory callbackFactory = runtime.callbackFactory(CsvParserService.class);
        mCsvParser.defineModuleFunction("parse_line", 
            callbackFactory.getSingletonMethod("parseLine", RubyString.class));
        return true;
    }
    
    public static IRubyObject parseLine(IRubyObject recv, RubyString line, Block unusedBlock) {
        Ruby runtime = recv.getRuntime();
 
        CharSequence seq = line.getValue();
        int length = seq.length();
        if (length == 0)
            return runtime.getNil();
        
        int state = UNQUOTED;
        StringBuilder value = new StringBuilder(length);   // field value, no longer than line
        RubyArray array = RubyArray.newArray(runtime, DEF_ARRAY_LEN);
        
        for (int i = 0; i < length; i++) {
            char c = seq.charAt(i);
            switch (c) {
                case ',':
                    if (state == UNQUOTED) {
                        if (value.length() == 0) {
                            array.append(runtime.getNil());
                        } 
                        else {
                            array.append(RubyString.newString(runtime, value));
                            value.setLength(0);
                        }
                    }
                    else if (state == IN_QUOTED) {
                        value.append(c);
                    }
                    else if (state == 2) {
                        array.append(RubyString.newString(runtime, value));
                        value.setLength(0);
                        state = UNQUOTED;
                    }
                    break;
                case '"':
                    if (state == UNQUOTED) {
                        state = IN_QUOTED;
                    }
                    else if (state == IN_QUOTED) {
                        state = QUOTE_IN_QUOTED;
                    }
                    else if (state == QUOTE_IN_QUOTED) {
                        value.append(c);   // escaped quote
                        state = IN_QUOTED;
                    }
                    break;
                case '\r':
                case '\n':
                    if (state == IN_QUOTED) {
                        value.append(c);
                    }
                    else {
                        i = length;  // only parse first line if multiline
                    }
                    break;
                default:
                    value.append(c);
                    break;
            }
        }
        if (state == UNQUOTED) {
            if (value.length() == 0) {
                array.append(runtime.getNil());
            } 
            else {
                array.append(RubyString.newString(runtime, value));
                value.setLength(0);
            }
        }
        else if (state == QUOTE_IN_QUOTED) {
            array.append(RubyString.newString(runtime, value));
        }
        return array;
    }
}
