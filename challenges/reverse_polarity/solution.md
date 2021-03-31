# [Reverse Polarity](https://ctflearn.com/challenge/230) (30)
"Reverse Polarity" seems to imply that the binary in this is backwards. <br />
However, reversing the binary in python and then dropping it into a [binary to ascii translator](https://www.rapidtables.com/convert/number/binary-to-ascii.html) outputs useless data. <br />
For some reason, it has nothing to do with changing the binary data in the challenge, you just have to convert the data to ascii by separating it into 8-bit sections. <br />
We get our flag: `CTF{Bit_Flippin}`
