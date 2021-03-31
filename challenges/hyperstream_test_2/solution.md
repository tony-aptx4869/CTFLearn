# [HyperStream Test 2](https://ctflearn.com/challenge/443) (30)
The text `ABAAAABABAABBABBAABBAABAAAAAABAAAAAAAABAABBABABBAAAAABBABBABABBAABAABABABBAABBABBAABB` appears to be binary with the values for 1 and 0 being A or B. I don't know what this has to do with bacon or HyperStream though. <br />
Converting the text to binary with `tr` and then decoding the binary into ascii doesn't yield anything useful. <br />
<br />
This was done with: <br />
`$ echo "ABAAAABABAABBABBAABBAABAAAAAABAAAAAAAABAABBABABBAAAAABBABBABABBAABAABABABBAABBABBAABB" | tr 'A' '1' | tr 'B' '0'` <br />
And tried again with `A` as `0` and `B` as `1`. <br />
When decoding the 8-bit separated binary into ascii, nothing useful is decoded. <br />
Useful information is gained by trying this, the binary is not 8-bit separated. <br />
<br />
**Bacon** is the hint here, after some searching I found [Bacon's cipher](https://en.wikipedia.org/wiki/Bacon%27s_cipher). <br />
The cipher encodes its message using a key-value table found in the *Cipher details* section. Each letter of the original text is transformed into a 5 character code of `A`s and `B`s. <br /><br />
First, let's separate the ciphertext into 5 characters using the `python` IDLE: <br />
```
>>> ciphertext = "ABAAAABABAABBABBAABBAABAAAAAABAAAAAAAABAABBABABBAAAAABBABBABABBAABAABABABBAABBABBAABB"
>>> from textwrap import wrap
>>> wrap(ciphertext, 5)
['ABAAA', 'ABABA', 'ABBAB', 'BAABB', 'AABAA', 'AAAAB', 'AAAAA', 'AAABA', 'ABBAB', 'ABBAA', 'AAABB', 'ABBAB', 'ABBAA', 'BAABA', 'BABBA', 'ABBAB', 'BAABB']
```
<br />
Now let's decode the array into letters using the table on [wikipedia](https://en.wikipedia.org/wiki/Bacon%27s_cipher). <br />
```
ABAAA = I or J
ABABA = L
ABBAB = O
BAABB = U or V
AABAA = E
AAAAB = B
AAAAA = A
AAABA = C
ABBAB = O
ABBAA = N
AAABB = D
ABBAB = O
ABBAA = N
BAABA = T
BABBA = Y
ABBAB = O
BAABB = U
```
You might be lead to believe the flag uses the V instead of a U but it's actually the other way around. <br />
Our flag: `ILOUEBACONDONTYOU` <br />
<br />
A Baconian cipher decoder can also be found [here](https://cryptii.com/pipes/bacon-cipher). <br />
