/*
 * Copyright (c) Maarten Oelering, BrightCode BV
 */

#include "ruby.h"
#ifdef RUBY_18
  #include "rubyio.h"
#else
  #include "ruby/io.h"
#endif

#define DEF_ARRAY_LEN 32

#define UNQUOTED 0
#define IN_QUOTED 1
#define QUOTE_IN_QUOTED 2

static VALUE mCsvParser;

static VALUE parse_line(VALUE self, VALUE str)
{
    if (NIL_P(str))
        return Qnil;
    
    const char *ptr = RSTRING_PTR(str);
    int len = (int) RSTRING_LEN(str);  /* cast to prevent warning in 64-bit OS */

    if (len == 0)
        return Qnil;
    
    VALUE array = rb_ary_new2(DEF_ARRAY_LEN); /* default allocated size is 16 */
    char value[len];  /* field value, no longer than line */
    int state = 0;
    int index = 0;
    int i;
    char c;
    for (i = 0; i < len; i++)
    {
        c = ptr[i];
        switch (c)
        {
            case ',':
                if (state == UNQUOTED) {
                    rb_ary_push(array, (index == 0 ? Qnil: rb_str_new(value, index)));
                    index = 0;
                }
                else if (state == IN_QUOTED) {
                    value[index++] = c;
                }
                else if (state == QUOTE_IN_QUOTED) {
                    rb_ary_push(array, rb_str_new(value, index));
                    index = 0;
                    state = UNQUOTED;
                }
                break;
            case '"':
                if (state == UNQUOTED) {
                    state = IN_QUOTED;
                }
                else if (state == 1) {
                    state = QUOTE_IN_QUOTED;
                }
                else if (state == QUOTE_IN_QUOTED) {
                    value[index++] = c;  /* escaped quote */
                    state = IN_QUOTED;
                }
                break;
            case 13:  /* \r */
            case 10:  /* \n */
                if (state == IN_QUOTED) {
                    value[index++] = c;
                }
                else {
                    i = len;  /* only parse first line if multiline */
                }
                break;
            default:
                value[index++] = c;
        }
    }
    
    if (state == UNQUOTED) {
        rb_ary_push(array, (index == 0 ? Qnil: rb_str_new(value, index)));
    }
    else if (state == QUOTE_IN_QUOTED) {
        rb_ary_push(array, rb_str_new(value, index));
    }
    return array;
}

void Init_csv_parser()
{
    mCsvParser = rb_define_module("CsvParser");
    rb_define_module_function(mCsvParser, "parse_line", parse_line, 1);
}
