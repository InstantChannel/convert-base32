convert-base32
=====

This module converts strings to/from Base32 encoding, and aims to be 100% compatible with Perl's Convert::Base32.

Ported from the Convert::Base32 Perl module authored by Tatsuhiko Miyagawa.

## Installation

  npm install convert-base32

## Usage

```
require! {
  \convert-base32
}

encoded = convert-base32.encode 'something special'
decoded = convert-base32.decode encoded

```

## Contributing

Please edit the LiveScript under the *src* dir. Run `make build` and commit the *src* and *lib* dirs.

## Release History

* 0.9.0 Initial release
