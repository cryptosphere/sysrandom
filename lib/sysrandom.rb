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

    def random_bytes(n = 16)
      raise ArgumentError, "negative string size" if n < 0

      bytes = Java::byte[n].new
      @_java_secure_random.nextBytes(bytes)
      String.from_java_bytes(bytes)
    end
  else
    require "sysrandom_ext"
  end
end
