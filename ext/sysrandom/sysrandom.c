#include "ruby.h"

/* How many bytes to generate by default, matching SecureRandom
 * Why SecureRandom has a default size argument is beyond me */
#define DEFAULT_N_BYTES 16

static VALUE mSysrandom = Qnil;

static VALUE Sysrandom_random_bytes(int argc, VALUE *argv, VALUE self);

/* From randombytes_sysrandom.c */
void __randombytes_sysrandom_buf(void * const buf, const size_t size);

void Init_sysrandom()
{
    mSysrandom = rb_define_module("Sysrandom");

    rb_define_singleton_method(mSysrandom, "random_bytes", Sysrandom_random_bytes, -1);
}

/**
 *  call-seq:
 *    Sysrandom#random_bytes(n=nil) -> String
 *
 * ::random_bytes generates a random binary string via the OS CSPRNG.
 *
 * The argument n specifies how long the resulting string should be.
 *
 * For compatibility with SecureRandom, if n is not specified, 16 is assumed.
 *
 * The resulting string may contain any byte (i.e. "x00" - "xff")
 *
 */
static VALUE
Sysrandom_random_bytes(int argc, VALUE * argv, VALUE self)
{
    VALUE n_obj, str;
    int n;

    if (rb_scan_args(argc, argv, "01", &n_obj) == 1) {
        n = NUM2INT(n_obj);

        if(n < 0) {
          rb_raise(rb_eArgError, "negative string size");
        }
    } else {
        n = DEFAULT_N_BYTES;
    }

    if(n > 0) {
        str = rb_str_new(0, n);
        __randombytes_sysrandom_buf(RSTRING_PTR(str), n);
    } else {
        str = rb_str_new2("");
    }

    return str;
}
