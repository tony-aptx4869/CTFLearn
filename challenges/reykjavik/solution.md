# [Reykjavik](https://ctflearn.com/challenge/990) (10)
Downloading the [file](https://ctflearn.com/challenge/download/990), we can unzip it with `unzip Reykjavik.zip` <br />
And view the contents with `ls` <br />
```
$ ls -p
readme  Reykjavik  sources.zip.enc
```

Displaying the contents of the `readme` with are presented with a large challenge description:
```
$ cat readme

This Reversing challenge is a great place to start if you are new to Reversing.

Reversing assumes you have a good understanding of assembler.

If you are interested in learning Assembler for Linux, there are lots of good resources available.
Here is a good place to start:
https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

If you find you are not quite ready for assembler yet (maybe you're not quite sure about bits and bytes yet
but you really want to learn...)
Check out these videos:
https://www.youtube.com/watch?v=tLdvEOam3sk&t=865s

There is a good Assembler tutorial site for 32 bit assembler:
https://asmtutor.com/

Note that the system calls are different between 32 and 64 bit Intel assembly.

Finally, liveoverflow on YouTube is excellent.  Check out his videos on reversing, CTF's etc:
https://www.youtube.com/channel/UClcE-kVhqyiHCcjYwcpfj9w

---------------------------------------------

If you go to the trouble to solve this reversing challenge, I want you to have the original sources used to
create the executable.

The file sources.zip.enc is encrypted with:
openssl enc -e -aes-256-cbc -pbkdf2 -k flag -in sources.zip -out sources.zip.enc

where flag is the solution to this challenge.  Solve the challenge, get the flag, decrypt the sources.

This should allow you to step through in the debugger after the fact if you are interested to answer
any questions about the original source used to create the challenge.

Please don't share the flag or these sources or how you solved this challenge, that ruins it for everyone.
I put a lot of thought and work into creating these challenges and don't want the flags or solutions
shared or put on a website where someone can get the flag without doing the work required.

I'm @kcbowhunter on Twitter and Discord.  This is only the second reversing challenge I have created, I'd be glad to
hear what you liked or disliked about this challenge to make the next ones I create better.  Thanks!
```

So we have to get the flag out of the executable `Reykjavik` and can use it to decrypt `sources.zip.enc` <br />

We can use `file` to get some info on `Reykjavik`: <br />
```
$ file Reykjavik
Reykjavik: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=9bc04368dbcefb4491573ac8feea3a32e31ed59f, for GNU/Linux 3.2.0, not stripped
```

It appears to be a shared object file but is actually executable: <br />
```
$ ./Reykjavik
Usage: Reykjavik CTFlearn{flag}
```

If we supply a flag we get: <br />
```
$ ./Reykjavik flag
Welcome to the CTFlearn Reversing Challenge Reykjavik v2: flag
Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse

Sorry Dude, 'flag' is not the flag :-(
```

We get some useful info here, the compilation options for the binary. <br />
`-O0` meaning compiler did not optimize the binary. <br />
`-fno-stack-protector` disables stack canaries <br />
`-mno-sse` means floating point arguments will be passed onto the stack instead of SSE registers, I don't know the importance of this. <br />

We can analyze the binary with `rabin2`:
```
$ rabin2 -I Reykjavik
arch     x86
binsz    14844
bintype  elf
bits     64
canary   false
class    ELF64
crypto   false
endian   little
havecode true
intrp    /lib64/ld-linux-x86-64.so.2
lang     c
linenum  true
lsyms    true
machine  AMD x86-64 architecture
maxopsz  16
minopsz  1
nx       true
os       linux
pcalign  0
pic      true
relocs   true
relro    full
rpath    NONE
static   false
stripped false
subsys   linux
va       true
```

We can analyze the strings section of the binary with `rabin2`:
```
$ rabin2 -z Reykjavik 
000 0x00002008 0x00002008  31  32 (.rodata) ascii Usage: Reykjavik CTFlearn{flag}
001 0x00002028 0x00002028  61  62 (.rodata) ascii Welcome to the CTFlearn Reversing Challenge Reykjavik v2: %s\n
002 0x00002068 0x00002068  70  71 (.rodata) ascii Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse\n
003 0x000020b0 0x000020b0  31  32 (.rodata) ascii CTFlearn{Is_This_A_False_Flag?}
004 0x000020d0 0x000020d0  37  38 (.rodata) ascii You found the false flag Dude!:'%s'\n\n
005 0x000020f8 0x000020f8  45  46 (.rodata) ascii Congratulations, you found the flag!!: '%s'\n\n
006 0x00002128 0x00002128  38  39 (.rodata) ascii Sorry Dude, '%s' is not the flag :-(\n\n
```

We know there is the false flag `CTFlearn{Is_This_A_False_Flag?}` now, so it can be ignored. <br />
And that when we do get the flag right, it will tell us Congratulations and echo the flag back. <br />

We can see all the imported functions that are called with `rabin2`:
```
$ rabin2 -i Reykjavik 
   1 0x00000000    WEAK  NOTYPE _ITM_deregisterTMCloneTable
   2 0x0000102a  GLOBAL    FUNC puts
   3 0x00000000  GLOBAL    FUNC __libc_start_main
   4 0x0000103a  GLOBAL    FUNC strcmp
   5 0x00000000    WEAK  NOTYPE __gmon_start__
   6 0x0000104a  GLOBAL    FUNC __printf_chk
   7 0x00000000    WEAK  NOTYPE _ITM_registerTMCloneTable
   8 0x00000000    WEAK    FUNC __cxa_finalize
   1 0x00000000    WEAK  NOTYPE _ITM_deregisterTMCloneTable
   3 0x00000000  GLOBAL    FUNC __libc_start_main
   5 0x00000000    WEAK  NOTYPE __gmon_start__
   7 0x00000000    WEAK  NOTYPE _ITM_registerTMCloneTable
   8 0x00000000    WEAK    FUNC __cxa_finalize
```

