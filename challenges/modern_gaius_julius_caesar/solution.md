# [Modern Gaius Julius Caesar](https://ctflearn.com/challenge/885) (30)
The challenge text seems to imply that either the alphabet or ascii is not way character values were shifted during encoding. <br />
> Why should you when you have your keyboard? <br />
Seems like shifting values based on a keyboard layout is the method used to encrypt the flag. <br />
However there are capital letters in the ciphertext, this is probably the work of ascii. <br />
When we assume the first 4 letters of ciphertext will decode to `flag`, we find that the ascii shift isn't constant. <br />
However, it's also common for a flag to begin with `CTFlearn`, and it seems like the first 3 characters being uppercase is a good indication of that. <br />
<br />
Using that thought process, we're able to compare the ascii values of the first few letters of ciphertext against the ascii values of the characters in `CTFLearn`, and we find that this method doesn't work either<br />
<br />
Continuing along, let's shift our focus to the keyboard, a this point i'm fairly certain the flag begins with `CTFlearn`, and when looking for the value `C` starting from `B` on my keyboard, we have to move left 2 keys. `U` -> `T`? left 2 keys. `H` -> `F`? left 2 keys. <br />
<br />
Continuing on this pattern, we're able to decipher the flag:<br />
flag: `CTFlearn{Cyb3r_Cae54r}` <br />
<br />
*Note that if you would have to hit shift when typing the ciphertext character, that shift will be applied to the decoding as well.* <br />
*Also note that different keyboards have different key placement, it's best to deduce what the cipher might be **trying** to convey.* <br />
