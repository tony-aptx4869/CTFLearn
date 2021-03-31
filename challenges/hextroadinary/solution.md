# [Hextroadinary](https://ctflearn.com/challenge/158) (30)
Looking at the hex given to us `0xc4115 0x4cf8` we can decode it them `rax2 -s <hex>`, however it outputs useless binary data <br />
Since something was done to the hex, lets try adding the values together: <br />
```
$ rax2 0xc4115+0x4cf8
822797
$ rax2 822797
0xc8e0d
```
Doesn't look like the flag to me, although it should start with `0x` <br /> 

Looking at the challenge text closer, ROXy has the first three letters capitalized, backwards they are [XOR](https://en.wikipedia.com/wiki/Exclusive_or), a bitwise operator. <br />

We can XOR the two hex values in python: <br />
```
$ python3
Python 3.6.9 (default, Jan 26 2021, 15:33:00) 
[GCC 8.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 0xc4115 ^ 0x4cf8
789997
>>> hex(789997)
'0xc0ded'
```

There we have it, our flag is `0xc0ded` <br />
