require! {
  chai: {expect}
  \../index : convert-base32
  child_process: cp
}

encode = convert-base32.encode
decode = convert-base32.decode

chars = [ ' ' to \~ ].join ''
perl-encoded = '''
eaqseizeeutcokbjfivsyljof4ydcmrtgq2tmnzyhe5dwpb5hy7uaqkcincekrshjbeuus2mjvhe6ucrkjjvivkwk5mfsws3lrov4x3amfrggzdfmztwq2lknnwg23tpobyxe43uov3ho6dzpj5xy7l6
'''
perl-decoded = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'

describe "Check our test setup ...", ->
  specify "chars matches perl-decoded", ->
    expect chars .to.equal perl-decoded

describe "Check our encodings ...", ->
  specify "we can decode what we encode", ->
    expect(decode(encode chars)).to.equal chars
  specify "encoded matches Perl's", ->
    expect(encode chars).to.equal perl-encoded
  specify "decoded matches Perl's", ->
    expect(decode(encode chars)).to.equal perl-decoded


