# [Character Encoding](https://https://ctflearn.com/challenge/115) (20)
These numbers are ascii encoded hexadecimal, we can decode them with rax2, included in radare2. <br />
`$ rax2 -s "41 42 43 54 46 7B 34 35 43 31 31 5F 31 35 5F 55 35 33 46 55 4C 7D"` <br />
our flag will be written to stdout: `ABCTF{45C11_15_U53FUL}`
