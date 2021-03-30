# [Forensics 101](https://ctflearn.com/challenge/96) (30)
At the [mega link](https://mega.nz/#!OHohCbTa!wbg60PARf4u6E6juuvK9-aDRe_bgEL937VO01EImM7c) we find a minion meme. <br />
My first thought is stenography, the art of hiding messages in images, so I downloaded the image. <br />
![Minion Meme](img/meme.jpg) <br />
A visual look at the image doesn't reveal anything, lets take a look at it's binary form. <br />
`cat meme.jpg` reveals the flag in the binary data output as `flag{wow!_data_is_cool}` <br />
An easier way to find the flag is to use `strings meme.jpg`, which filters out discernable text from the binary data <br />
