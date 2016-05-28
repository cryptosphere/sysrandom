require "sysrandom/version"

# Secure random number generation using system RNG facilities
module Sysrandom
  module_function

  if defined?(JRUBY_VERSION)
    require "java"

    if java.security.SecureRandom.respond_to?(:getInstanceStrong)
      @_java_secure_random = java.security.SecureRandom.getInstanceStrong
    else
      @_java_secure_random = java.security.SecureRandom.getInstance("SHA1PRNG")
    end

    # Random uint32, used by random_number. The C extension provides an equivalent method
    def __random_uint32
      @_java_secure_random.nextLong & 0xFFFFFFFF
    end

    def random_bytes(n = 16)
      raise ArgumentError, "negative string size" if n < 0

      bytes = Java::byte[n].new
      @_java_secure_random.nextBytes(bytes)
      String.from_java_bytes(bytes)
    end
  else
    require "sysrandom_ext"
  end

  def random_number(n = 0)
    result = __random_uint32 / (2**32).to_f

    if n <= 0
      result
    else
      result *= n
      n.is_a?(Fixnum) ? result.floor : result
    end
  end
end
