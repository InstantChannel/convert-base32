#!/usr/bin/env lsc

# This module ported from the Perl module authored by Tatsuhiko Miyagawa.
# See: https://metacpan.org/pod/Convert::Base32

require! {
  \sprintf-js
}

bits2char = {}
char2bits = []
syms = [ \a to \z ] ++ [ '2' to '7' ]

syms.for-each (sym, idx) ->
  bin = sprintf-js.sprintf \%05b, idx
  char2bits[ sym.to-lower-case!char-code-at! ] = bin
  char2bits[ sym.to-upper-case!char-code-at! ] = bin
  do
    bits2char[pump?bin or bin] = sym
    pump = { bin } unless pump # avoid const compilation error
  while pump.bin.match(/[\s\S]+0$/) and pump.bin = pump.bin.replace /([\s\S]+)0$/, \$1

# function inspired by:
# author: Sarath Chandra
# see: http://blog.sarathonline.com/2009/02/javascript-convert-strings-to-binary.html
function str-to-bin str
  pump = {} # avoid const compilation error
  arr = []
  len = str.length
  pump.i = 1
  while pump.i <= len
    pump.d = str.char-code-at len - pump.i
    pump.j = 0
    while pump.j < 8
      arr.push pump.d % 2
      pump.d = Math.floor pump.d / 2
      pump.j++
    pump.i++
  # zero-pad last octet
  binary-str = arr.reverse!join ''
  binary-str.concat(if binary-str.length % 5 then \0 * (5 - that) else '')

# ABC - a generic, native JS (A)scii(B)inary(C)onverter.
# (c) 2013 Stephan Schmitz <eyecatchup@gmail.com>
# License: MIT, http://eyecatchup.mit-license.org
# URL: https://gist.github.com/eyecatchup/6742657
function bin-to-str bin
  bin.replace /\s*[01]{8}\s*/g, ((bin) -> String.from-char-code(parse-int bin, 2))

module.exports =
  encode: (str) ->
    str.split '' .for-each (char) ->
      throw new Error 'Data contains non-bytes' if char.char-code-at! > 127
    binary-str = str-to-bin str
    binary-str.replace /([\s\S]{5})/g, ((m, p1) -> bits2char[p1])

  decode: (str) ->
    throw new Error 'Data contains non-base32 characters' if str.match /[^a-z2-7]/i
    binary-str = str.replace /([\s\S])/g, ((m, p1) -> char2bits[p1.char-code-at!])
    padding = binary-str.length % 8
    throw new Error 'Length of data invalid' unless padding < 5
    padding-re = new RegExp "0{#padding}$"
    if binary-str.match padding-re
      bin-to-str(binary-str.replace padding-re, '')
    else
      throw new Error 'Padding bits at the end of output buffer are not all zero'

