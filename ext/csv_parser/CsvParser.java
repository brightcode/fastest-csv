//
// Copyright (c) Maarten Oelering, BrightCode BV
//

package org.brightcode;

import java.util.ArrayList;
import java.util.List;

public class CsvParser {

    private static int DEF_ARRAY_LEN = 32;

    private static int UNQUOTED = 0;
    private static int IN_QUOTED = 1;
    private static int QUOTE_IN_QUOTED = 2;
    
    public static List parseLine(String line) {
        int length = line.length();
        if (length == 0)
            return null;
        
        int state = UNQUOTED;
        StringBuilder value = new StringBuilder(length);   // field value, no longer than line
        List<String> array = new ArrayList<String>(DEF_ARRAY_LEN);
        
        for (int i = 0; i < length; i++) {
            char c = line.charAt(i);
            switch (c) {
                case ',':
                    if (state == UNQUOTED) {
                        if (value.length() == 0) {
                            array.add(null);
                        } 
                        else {
                            array.add(value.toString());
                            value.setLength(0);
                        }
                    }
                    else if (state == IN_QUOTED) {
                        value.append(c);
                    }
                    else if (state == 2) {
                        array.add(value.toString());
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
                array.add(null);
            } 
            else {
                array.add(value.toString());
                value.setLength(0);
            }
        }
        else if (state == QUOTE_IN_QUOTED) {
            array.add(value.toString());
        }
        return array;
    }
}
