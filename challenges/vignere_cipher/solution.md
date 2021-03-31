# [Vignere Cipher](https://ctflearn.com/challenge/305) (20)
The flag is encrypted in a [Vignere cipher](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher), as the challenge states, thats a series of [Caesar ciphers](https://en.wikipedia.org/wiki/Caesar_cipher). <br />
The challenge gives use the ciphertext: `gwox{RgqssihYspOntqpxs}` <br />
The challenge also gives us what I believe to be the key: `blorpy` <br />
We can use an online [Vignere cipher decoder](https://dcode.fr/vigenere-cipher) to get the flag. <br />
To do it by hand, you can use the table below, match the nth cipher letter with the nth keystream letter to decipher the flag. <br />
![Vignere cipher table](https://www.dcode.fr/tools/vigenere/images/table.png) <br />
The flag is `flag{CiphersAreAwesome}`
