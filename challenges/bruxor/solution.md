# [BruXOR](https://ctflearn.com/challenge/227) (20)
The first hints we get are that this challenge utilizes the [XOR operation](https://en.wikipedia.org/wiki/Exclusive_or) and we need to bruteforce it. <br />
The message is `q{vpln'bH_varHuebcrqxetrHOXEj` <br />
Seems like the ascii characters were XOR'ed with some other value <br />
If the [last challenge](https://github.com/XNUConner/CTFLearn/edit/master/challenges/qr_code/solution.md) was anything to go off of, guessing part of the decoded ciphertext could give us a clue. <br />
<br />
The decoded ciphertext probably starts with `flag` <br />
[ascii.cl](https://ascii.cl) shows that that ascii value of **f** is 102. <br />
The first letter in the ciphertext is **q**, which has a value of 113. <br />
What can we XOR with 102 to equal 113? <br />
<br />
We can open the `python` IDLE and get to work with `102 ^ 1` and start counting up... <br />
I started by bruteforcing all possible values until we got the output of 113 <br />
`102 ^ 23 = 113`, we got it, now let's see if this hold up with the second value in the ciphertext compared to **l**. <br />
**l**s ascii value is `108`, `108 ^ 23 = 123`, which is the ascii value of **{**, the next character in our ciphertext. Looks like we've almost cracked the code. <br />
<br />

We need the inverse of the XOR function to calculate the flag characters, and [the inverse of XOR is actually XOR](https://stackoverflow.com/questions/14279866/what-is-inverse-function-to-xor) <br />
This means that the same XOR value used to encrypt this message (23) is the same one we can use to decrypt it <br />
Let's decrypt the ciphertext with a simple C program: <br />
```
int main(void) {
    char* ciphertext = "q{vpln'bH_varHuebcrqxetrHOXEj";
    while(*ciphertext) {
        printf("%c",*ciphertext ^ 23);
        ciphertext++;
    }
}
```
Our output is the flag: `flag{y0u_Have_bruteforce_XOR}` <br />
