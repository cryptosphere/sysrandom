# Sysrandom

[![Gem Version](https://badge.fury.io/rb/sysrandom.svg)](https://rubygems.org/gems/sysrandom)
[![Build Status](https://secure.travis-ci.org/cryptosphere/sysrandom.svg?branch=master)](https://travis-ci.org/cryptosphere/sysrandom)
[![ISC licensed](https://img.shields.io/badge/license-ISC-blue.svg)](https://github.com/cryptosphere/sysrandom/blob/master/LICENSE.txt)

Secure random number generation for Ruby using system RNG facilities e.g. `/dev/urandom`, `getrandom(2)`

## Description

[Concerns have been raised][concerns] about the current implementation of Ruby's built-in
`SecureRandom` functionality, as it presently leverages the poorly reputed OpenSSL RNG.

In cryptography circles, [the prevailing advice is to use OS RNG functionality][/dev/urandom],
namely `/dev/urandom` or equivalent calls which use an OS-level CSPRNG to
produce random numbers.

This gem provides an easy-to-install repackaging of the `randombytes`
functionality from [libsodium] for the purpose of generating secure random
numbers trustworthy for use in cryptographic contexts, such as generating
cryptographic keys, initialization vectors, or nonces.

The following random number generators are utilized:

| OS      | RNG                                                               |
|---------|-------------------------------------------------------------------|
| Linux   | [getrandom(2)] if available, otherwise [/dev/urandom]             |
| Windows | [RtlGenRandom]                                                    |
| OpenBSD | [arc4random(3)] with ChaCha20 CSPRNG (not RC4)                    |
| JRuby   | [SecureRandom.getInstanceStrong] if available, otherwise SHA1PRNG |
| Others  | [/dev/urandom]                                                    |

[concerns]:      https://bugs.ruby-lang.org/issues/9569
[libsodium]:     https://github.com/jedisct1/libsodium
[getrandom(2)]:  http://man7.org/linux/man-pages/man2/getrandom.2.html
[/dev/urandom]:  http://sockpuppet.org/blog/2014/02/25/safely-generate-random-numbers/
[RtlGenRandom]:  https://msdn.microsoft.com/en-us/library/windows/desktop/aa387694(v=vs.85).aspx
[arc4random(3)]: http://man.openbsd.org/arc4random.3
[SecureRandom.getInstanceStrong]: https://docs.oracle.com/javase/8/docs/api/java/security/SecureRandom.html#getInstanceStrong--

## Supported Platforms

Sysrandom is tested on the following Ruby implementations:

* Ruby (MRI) 2.0, 2.1, 2.2, 2.3
* JRuby 9.1.1.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sysrandom'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sysrandom

## Usage

`Sysrandom` aims to be API-compatible with Ruby's built-in `SecureRandom` class,
but always prefers OS-level RNG wherever it's available:

```ruby
>> Sysrandom.random_number(42)
=> 15
>> Sysrandom.random_bytes(32)
=> "\xD6J\xB3\xD2\x8B\x7F*9D\xB7\xF9\xEA\xE2\\\xAAH\tV#\xEC\x84\xE3E\r\x97\xB9\b\xFCH\x17\xA0\v"
>> Sysrandom.base64(32)
=> "WXPkxfAuLRpnI6Z4zFb4E+MIenx6w6vKhe01+rMPuIQ="
>> Sysrandom.urlsafe_base64(32)
=> "37rsMfR4X8g7Bb-uDJEekRHnB3r_7nO03cv52ilaWqE="
>> Sysrandom.hex(32)
=> "c950496ce200abf7d18eb1414e9206c6335f971a37d0394114f56439b59831ba"
>> Sysrandom.uuid
=> "391c6f52-8017-4838-9790-131a9b979c63"
```

* [SecureRandom API docs](http://ruby-doc.org/stdlib-2.0.0/libdoc/securerandom/rdoc/SecureRandom.html)

## Contributing

* Fork this repository on Github
* Make your changes and send a pull request
* If your changes look good, we'll merge them

## Copyright

Copyright (c) 2013-2016 Frank Denis, Tony Arcieri. See LICENSE.txt for further details.
