#!/usr/bin/env perl

my $chars = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~' ;

my @syms = ( 'a'..'z', '2'..'7' );

my %bits2char;
my @char2bits;

for (0..$#syms) {
  my $sym = $syms[$_];
  my $bin = sprintf('%05b', $_);

  $char2bits[ ord lc $sym ] = $bin;
  $char2bits[ ord uc $sym ] = $bin;

  do {
    $bits2char{$bin} = $sym;
  } while $bin =~ s/(.+)0\z/$1/s;
}

my $enc = encode_base32_perl58($chars) ;
my $dec = decode_base32_perl58($enc) ;

print $enc, "\n" ;
print $dec, "\n" ;
exit 1 unless $dec eq $chars ;
exit 0 ;

sub encode_base32_perl58($) {
    $_[0] =~ tr/\x00-\xFF//c
  and Carp::croak('Data contains non-bytes');

    my $str = unpack('B*', $_[0]);

    if (length($str) < 8*1024) {
  return join '', @bits2char{ unpack '(a5)*', $str };
    } else {
  # Slower, but uses less memory
  while ($str =~ m/(.{5})/s) {
    $str =~ s/(.{5})/$bits2char{$1}/s ;
  }
  return $str;
    }
}

sub decode_base32_perl58($) {
    $_[0] =~ tr/a-zA-Z2-7//c
  and Carp::croak('Data contains non-base32 characters');

    my $str;
    if (length($_[0]) < 8*1024) {
  $str = join '', @char2bits[ unpack 'C*', $_[0] ];
    } else {
  # Slower, but uses less memory
  ($str = $_[0]) =~ s/(.)/$char2bits[ord($1)]/sg;
    }

    my $padding = length($str) % 8;
    $padding < 5
  or Carp::croak('Length of data invalid');
    $str =~ s/0{$padding}\z//
  or Carp::croak('Padding bits at the end of output buffer are not all zero');

    return pack('B*', $str);
}
