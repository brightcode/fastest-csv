/*
 * Copyright (c) Maarten Oelering, BrightCode BV
 */

#include "ruby.h"
#ifdef RUBY_18
  #include "rubyio.h"
#else
  #include "ruby/io.h"
#endif

/* default allocated size is 16 */
#define DEF_ARRAY_LEN 32

static VALUE cFastestCSV;

static VALUE parse_line(VALUE self, VALUE str)
{
    if (NIL_P(str))
        return Qnil;
    
    const char *ptr = RSTRING_PTR(str);
    int len = (int) RSTRING_LEN(str);  /* cast to prevent warning in 64-bit OS */

    if (len == 0)
        return Qnil;
    
    VALUE array = rb_ary_new2(DEF_ARRAY_LEN); 
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
                if (state == 0) {
                    rb_ary_push(array, (index == 0 ? Qnil: rb_str_new(value, index)));
                    index = 0;
                }
                else if (state == 1) {
                    value[index++] = c;
                }
                else if (state == 2) {
                    rb_ary_push(array, rb_str_new(value, index));
                    index = 0;
                    state = 0;  /* outside quoted */
                }
                break;
            case '"':
                if (state == 0) {
                    state = 1;  /* in quoted */
                }
                else if (state == 1) {
                    state = 2;  /* quote in quoted */
                }
                else if (state == 2) {
                    value[index++] = c;  /* escaped quote */
                    state = 1;  /* in quoted */
                }
                break;
            case 13:  /* \r */
            case 10:  /* \n */
                if (state == 1) { /* quoted */
                    value[index++] = c;
                }
                else {
                    /* only do first line */
                    i = len;
                }
                /* else eat it ??? or return so far */
                break;
            default:
                value[index++] = c;
        }
    }
    
    if (state == 0) {
        rb_ary_push(array, (index == 0 ? Qnil: rb_str_new(value, index)));
    }
    else if (state == 2) {
        rb_ary_push(array, rb_str_new(value, index));
    }
    return array;
}

void Init_csv_parser()
{
    cFastestCSV = rb_define_class("FastestCSV", rb_cObject);
    rb_define_singleton_method(cFastestCSV, "parse_line", parse_line, 1);
}
