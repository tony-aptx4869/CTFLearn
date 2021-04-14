# [Blank Page](https://ctflearn.com/challenge/959) (30)
using `cat`, we see that [TheMessage.txt](https://ctflearn.com/challenge/download/959) is completely blank. <br />
We can open the file in a hex editor, we see that the file is comprised of 4 different bytes: `0x20, 0xe2, 0x80, 0x8f` <br />

We can separate the file by single hex bytes in `xxd`: <br />
```
$ xxd -g 1 TheMessage.txt
00000000: 20 e2 80 8f 20 20 20 e2 80 8f e2 80 8f 20 20 e2   ...   ......  .
00000010: 80 8f e2 80 8f e2 80 8f 20 20 e2 80 8f 20 20 e2  ........  ...  .
00000020: 80 8f e2 80 8f 20 e2 80 8f e2 80 8f e2 80 8f e2  ..... ..........
00000030: 80 8f 20 e2 80 8f e2 80 8f 20 e2 80 8f e2 80 8f  .. ...... ......
00000040: 20 e2 80 8f 20 20 e2 80 8f 20 20 20 20 20 20 e2   ...  ...      .
(...)
```

*Super Agent School* can be abbreviated as SAS, if we google SAS we find statistical analysis software, but it's a hassle to download and the comments on this CTF say not to overthink it, so it's not anything to do with analysis. <br />

With a close look at the hex, we find that `e2 80 8f` characters are always together in a 3 byte repeating sequence. <br />
I think this could be morse code, but morse code requires a character delimiter, so the only option I can think of is binary, we can write a python script to turn the `e2 80 8f` characters into `1` and the `20` into `0`. <br />

Here's what I wrote:
```
with open("TheMessage.txt", "r") as f:
	for line in f:
		for ch in line:
			ur = ord(ch)
			if ur == 32:
				print('0', end='')
			if ur == 8207:
				print('1', end='')
```
Reading a `0x20` byte has the `ord()` unicode equivalent value of `32` <br />
We only need the first byte (`e2`) in the `e2 80 ef` sequence to know it's a `1`, it's unicode equivalent value is `8207` <br />

Our program gives us this output: <br />
```
$ python3 script.py
01000110011100100110111101101101001000000101010001101000011001010010000001000111011011000110111101100010011000010110110000100000010000010110111001110100011010010010110101010100011001010111001001110010011011110111001001101001011100110111010001110011001000000101010001100001011000110111010001101001011000110111001100001010000010100100100101100110001000000111100101101111011101010010000001110010011001010110000101100100001000000111010001101000011010010111001100100000011110010110111101110101001000000111000001100001011100110111001101100101011001000010111000100000010000110110111101101110011001110111001001100001011101000111001100101110000010100101100101101111011101010111001000100000011001100110100101110010011100110111010000100000011101000110000101110011011010110010000001110111011010010110110001101100001000000110001101101111011011010110010100100000011101000110111101101101011011110111001001110010011011110111011100101110000010100100011101101111011011110110010000100000011011000111010101100011011010110010111000001010000010100100001101010100010001100110110001100101011000010111001001101110011110110100100101100110010111110111100100110000011101010101111101110010001100110010111101011100011001000101111101110100011010000110100100110101010111110111100101101111011101010101111101110000011000010011010100110101001100110110010001111101
```

We can copy-paste this output into an [online binary decoder](https://cryptii.com/pipes/binary-decoder) to get the message: <br />
```
From The Global Anti-Terrorists Tactics

If you read this you passed. Congrats.
Your first task will come tomorrow.
Good luck.

CTFlearn{If_y0u_r3/\d_thi5_you_pa553d}
```

Our flag is `CTFlearn{If_y0u_r3/\d_thi5_you_pa553d}` <br />
