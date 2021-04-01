# [Pho Is Tasty!](https://ctflearn.com/challenge/971) (30)
Upon downloading and opening the [image](https://ctflearn.com/challenge/download/971) we are presented with: <br />
![Pho](img/Pho.jpg) <br />
`strings Pho.jpg` reveals nothing but exif data. <br />
`exif Pho.jpg` claims the image is corrupt. <br />
`foremost Pho.jpg` doesn't find any images hidden inside. <br />
<br />
Seems we're at a dead end here. <br />
<br />
After reading the comments saying to use a hex viewer, I used `xxd` to view the hex: <br />
```
00000000: ffd8 ffe0 0010 4a46 4946 0001 0100 0001  ......JFIF......
00000010: 0001 0000 ffe3 006f 5361 6d73 756e 6700  .......oSamsung.
00000020: 5361 6d73 756e 6720 4761 6c61 7879 2053  Samsung Galaxy S
00000030: 3820 436f 6c6f 7220 5061 6c65 7474 653a  8 Color Palette:
00000040: 1d09 4304 1554 0206 4614 0d6c 160e 6506  ..C..T..F..l..e.
00000050: 1961 171f 721b 186e 010c 7b04 0749 0f03  .a..r..n..{..I..
00000060: 5f02 0e4c 1618 6f1f 0476 190c 651f 065f  _..L..o..v..e.._
00000070: 1801 5011 1068 1314 6f1a 0221 0402 2113  ..P..h..o..!..!.
00000080: 1421 0b14 7dff db00 8400 0808 0808 0808  .!..}...........
```
Staring right at us the entire time, but obfuscated by the random hex values between the flag characters. That's why `strings` doesn't provide anything useful <br />
Flag: `CTFlearn{I_Love_Pho!!!}` <br />
