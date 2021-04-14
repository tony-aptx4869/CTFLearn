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

We can analyze the binary with `rabin2`: <br />
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

We can analyze the strings section of the binary with `rabin2`: <br />
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

We can see all the imported functions that are called with `rabin2`: <br />
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

To solve this CTF, we have to analyze the program in a debugger, and step through the execution, just like the challenge text suggests. <br />
We can debug the program with `radare2`, using `r2 -A -d ./Reykjavik my_flag`: <br />
```
$ r2 -A -d ./Reykjavik my_flag
Process with PID 22844 started...
= attach 22844 22844
bin.baddr 0x56266ab10000
Using 0x56266ab10000
asm.bits 64
[Cannot find function 'entry0' at 0x56266ab111f0ry0 (aa)
[x] Analyze all flags starting with sym. and entry0 (aa)
[x] Analyze len bytes of instructions for references (aar)
[x] Analyze function calls (aac)
[x] Use -AA or aaaa to perform additional experimental analysis.
[x] Constructing a function name for fcn.* and sym.func.* functions (aan)
= attach 22844 22844
22844
[0x7f4e2b826090]> 
```

Now let's set a breakpoint for the `main()` function and continue execution until we start it: <br />
```
[0x7f4e2b826090]> db main
[0x7f4e2b826090]> dc
hit breakpoint at: 56266ab110a0
[0x56266ab110a0]> 
```

We can print the disassembly at this memory address with `pd`: <br />
```
[0x56266ab110a0]> pd
            ;-- main:
            ;-- section_end..plt.sec:
            ;-- section..text:
            ;-- main:
            ;-- rax:
            ;-- rip:
            0x56266ab110a0 b    f3             invalid                 ; [16] --r-x section size 693 named .text
            0x56266ab110a1      0f             invalid
            0x56266ab110a2      1e             invalid
            0x56266ab110a3      fa             cli
            0x56266ab110a4      4155           push r13
            0x56266ab110a6      4154           push r12
            0x56266ab110a8      55             push rbp
            0x56266ab110a9      4883ec20       sub rsp, 0x20
            0x56266ab110ad      83ff01         cmp edi, 1              ; 1
        ,=< 0x56266ab110b0      0f84ff000000   je 0x56266ab111b5
        |   0x56266ab110b6      488b6e08       mov rbp, qword [rsi + 8] ; [0x8:8]=-1 ; 8
        |   0x56266ab110ba      bf01000000     mov edi, 1
        |   0x56266ab110bf      31c0           xor eax, eax
        |   0x56266ab110c1      488d35600f00.  lea rsi, qword str.Welcome_to_the_CTFlearn_Reversing_Challenge_Reykjavik_v2:__s ; 0x56266ab12028 ; "Welcome to the CTFlearn Reversing Challenge Reykjavik v2: %s\n"
        |   0x56266ab110c8      4889ea         mov rdx, rbp
        |   0x56266ab110cb      e8c0ffffff     call 0x56266ab11090
        |   0x56266ab110d0      488d3d910f00.  lea rdi, qword str.Compile_Options:___CMAKE_CXX_FLAGS___O0__fno_stack_protector__mno_sse ; 0x56266ab12068 ; "Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse\n"
        |   0x56266ab110d7      e894ffffff     call 0x56266ab11070
        |   0x56266ab110dc      488d15cd0f00.  lea rdx, qword str.CTFlearn_Is_This_A_False_Flag ; 0x56266ab120b0 ; "CTFlearn{Is_This_A_False_Flag?}"
        |   0x56266ab110e3      b920000000     mov ecx, 0x20           ; 32
        |   0x56266ab110e8      4889ee         mov rsi, rbp
        |   0x56266ab110eb      4889d7         mov rdi, rdx
        |   0x56266ab110ee      f3a6           repe cmpsb byte [rsi], byte ptr [rdi] ; [0x2700000000:1]=255 ; 167503724544
        |   0x56266ab110f0      0f97c0         seta al
        |   0x56266ab110f3      1c00           sbb al, 0
        |   0x56266ab110f5      84c0           test al, al
       ,==< 0x56266ab110f7      0f84cc000000   je 0x56266ab111c9
       ||   0x56266ab110fd      488b150c2f00.  mov rdx, qword obj.data ; [0x56266ab14010:8]=0xc5d9cacec7edffe8
       ||   0x56266ab11104      4989e5         mov r13, rsp
       ||   0x56266ab11107      4889ee         mov rsi, rbp
       ||   0x56266ab1110a      c644241b00     mov byte [rsp + 0x1b], 0
       ||   0x56266ab1110f      48b8abababab.  movabs rax, -0x5454545454545455
       ||   0x56266ab11119      4c89ef         mov rdi, r13
       ||   0x56266ab1111c      4831c2         xor rdx, rax
       ||   0x56266ab1111f      48891424       mov qword [rsp], rdx
       ||   0x56266ab11123      488b15ee2e00.  mov rdx, qword [0x56266ab14018] ; [0x56266ab14018:8]=0xdd9be7f4ced2eed0
       ||   0x56266ab1112a      4831c2         xor rdx, rax
       ||   0x56266ab1112d      483305ec2e00.  xor rax, qword [0x56266ab14020]
       ||   0x56266ab11134      4889442410     mov qword [rsp + 0x10], rax
       ||   0x56266ab11139      0fb605e82e00.  movzx eax, byte [0x56266ab14028] ; [0x56266ab14028:1]=207
       ||   0x56266ab11140      4889542408     mov qword [rsp + 8], rdx
       ||   0x56266ab11145      83f0ab         xor eax, 0xffffffab
       ||   0x56266ab11148      88442418       mov byte [rsp + 0x18], al
       ||   0x56266ab1114c      0fb605d62e00.  movzx eax, byte [0x56266ab14029] ; [0x56266ab14029:1]=244
       ||   0x56266ab11153      83f0ab         xor eax, 0xffffffab
       ||   0x56266ab11156      88442419       mov byte [rsp + 0x19], al
       ||   0x56266ab1115a      0fb605c92e00.  movzx eax, byte [0x56266ab1402a] ; [0x56266ab1402a:1]=214
       ||   0x56266ab11161      83f0ab         xor eax, 0xffffffab
       ||   0x56266ab11164      8844241a       mov byte [rsp + 0x1a], al
       ||   0x56266ab11168      e813ffffff     call 0x56266ab11080
       ||   0x56266ab1116d      4189c4         mov r12d, eax
       ||   0x56266ab11170      85c0           test eax, eax
      ,===< 0x56266ab11172      7523           jne 0x56266ab11197
      |||   0x56266ab11174      4c89ea         mov rdx, r13
      |||   0x56266ab11177      488d357a0f00.  lea rsi, qword str.Congratulations__you_found_the_flag__:___s ; 0x56266ab120f8 ; "Congratulations, you found the flag!!: '%s'\n\n"
      |||   0x56266ab1117e      bf01000000     mov edi, 1
      |||   0x56266ab11183      31c0           xor eax, eax
      |||   0x56266ab11185      e806ffffff     call 0x56266ab11090
      |||   0x56266ab1118a      4883c420       add rsp, 0x20
      |||   0x56266ab1118e      4489e0         mov eax, r12d
      |||   0x56266ab11191      5d             pop rbp
      |||   0x56266ab11192      415c           pop r12
      |||   0x56266ab11194      415d           pop r13
      |||   0x56266ab11196      c3             ret
[0x56266ab110a0]> 
```

There's a lot going on here, but we know we're in the right place because we see the same strings we analyzed earlier. <br />

To make a long analysis short, this section of assembly simply checks if our argument count is enought to contain the flag: <br />
```
            0x56266ab110a0 b    f3             invalid                 ; [16] --r-x section size 693 named .text
            0x56266ab110a1      0f             invalid
            0x56266ab110a2      1e             invalid
            0x56266ab110a3      fa             cli
            0x56266ab110a4      4155           push r13
            0x56266ab110a6      4154           push r12
            0x56266ab110a8      55             push rbp
            0x56266ab110a9      4883ec20       sub rsp, 0x20
            0x56266ab110ad      83ff01         cmp edi, 1              ; 1
        ,=< 0x56266ab110b0      0f84ff000000   je 0x56266ab111b5
        |   0x56266ab110b6      488b6e08       mov rbp, qword [rsi + 8] ; [0x8:8]=-1 ; 8
        |   0x56266ab110ba      bf01000000     mov edi, 1
        |   0x56266ab110bf      31c0           xor eax, eax
        |   0x56266ab110c1      488d35600f00.  lea rsi, qword str.Welcome_to_the_CTFlearn_Reversing_Challenge_Reykjavik_v2:__s ; 0x56266ab12028 ; "Welcome to the CTFlearn Reversing Challenge Reykjavik v2: %s\n"
        |   0x56266ab110c8      4889ea         mov rdx, rbp
        |   0x56266ab110cb      e8c0ffffff     call 0x56266ab11090
        |   0x56266ab110d0      488d3d910f00.  lea rdi, qword str.Compile_Options:___CMAKE_CXX_FLAGS___O0__fno_stack_protector__mno_sse ; 0x56266ab12068 ; "Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse\n"
        |   0x56266ab110d7      e894ffffff     call 0x56266ab11070
        |   0x56266ab110dc      488d15cd0f00.  lea rdx, qword str.CTFlearn_Is_This_A_False_Flag ; 0x56266ab120b0 ; "CTFlearn{Is_This_A_False_Flag?}"
```

We can set a breakpoint ahead at `0x56266ab110e3` and continue execution: <br />
```
[0x56266ab110a0]> db 0x56266ab110e3
[0x56266ab110a0]> dc
Welcome to the CTFlearn Reversing Challenge Reykjavik v2: my_flag
Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse

hit breakpoint at: 56266ab110e3
[0x56266ab110e3]> 
```

Now our `rip` register is just about to execute the instruction @ `0x56266ab110e3`, the chunk of assembly below checks if our input flag (argv[1]) is `CTFlearn{Is_This_A_False_Flag?}`: <br />
```
            0x56266ab110e3 b    b920000000     mov ecx, 0x20           ; 32
            0x56266ab110e8      4889ee         mov rsi, rbp
            0x56266ab110eb      4889d7         mov rdi, rdx
            0x56266ab110ee      f3a6           repe cmpsb byte [rsi], byte ptr [rdi] ; [0x2700000000:1]=255 ; 167503724544
            0x56266ab110f0      0f97c0         seta al
            0x56266ab110f3      1c00           sbb al, 0
            0x56266ab110f5      84c0           test al, al
        ,=< 0x56266ab110f7      0f84cc000000   je 0x56266ab111c9

```

Since our first argument is different, we can set a breakpoint @ `0x56266ab110fd` right after the `je` and continue execution: <br />
```
[0x56266ab110e3]> db 0x56266ab110fd
[0x56266ab110e3]> dc
hit breakpoint at: 56266ab110fd
[0x56266ab110e3]> 
```

Now we're about to execute an important chunk of assembly that will eventually reveal part of the flag: <br />
```
        |   0x56266ab110fd b    488b150c2f00.  mov rdx, qword obj.data ; [0x56266ab14010:8]=0xc5d9cacec7edffe8
        |   0x56266ab11104      4989e5         mov r13, rsp
        |   0x56266ab11107      4889ee         mov rsi, rbp
        |   0x56266ab1110a      c644241b00     mov byte [rsp + 0x1b], 0
```

This code loads the hex value `0xc5d9cacec7edffe8` into `rdx`, and zeros out the stack at offset `0x1b`. <br />
Continuing execution, we have this chunk: <br />
```
        |   0x56266ab1110f      48b8abababab.  movabs rax, -0x5454545454545455
        |   0x56266ab11119      4c89ef         mov rdi, r13
        |   0x56266ab1111c      4831c2         xor rdx, rax
        |   0x56266ab1111f      48891424       mov qword [rsp], rdx

```
This chunk XORs the value we just stored in `rdx` with the value in `rax`, and moves the result to the stack. <br />

We can see what the stack looks like right now with `px @ rsp`: <br />
```
[0x56266ab110e3]> db 0x56266ab11123
[0x56266ab110e3]> dc
hit breakpoint at: 56266ab11123
[0x56266ab110e3]> px @ rsp
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffc83675ac0  4354 466c 6561 726e 0000 0000 0000 0000  CTFlearn........
0x7ffc83675ad0  e012 b16a 2656 0000 f011 b100 2656 0000  ...j&V......&V..
0x7ffc83675ae0  e012 b16a 2656 0000 f011 b16a 2656 0000  ...j&V.....j&V..
0x7ffc83675af0  d05b 6783 fc7f 0000 f75b 452b 4e7f 0000  .[g......[E+N...
0x7ffc83675b00  0200 0000 0000 0000 d85b 6783 fc7f 0000  .........[g.....
0x7ffc83675b10  0080 0000 0200 0000 a010 b16a 2656 0000  ...........j&V..
0x7ffc83675b20  0000 0000 0000 0000 0c9b 8cb2 9705 32fc  ..............2.
0x7ffc83675b30  f011 b16a 2656 0000 d05b 6783 fc7f 0000  ...j&V...[g.....
0x7ffc83675b40  0000 0000 0000 0000 0000 0000 0000 0000  ................
0x7ffc83675b50  0c9b 4c21 3bd6 87af 0c9b 1220 7f86 e2ae  ..L!;...... ....
0x7ffc83675b60  0000 0000 fc7f 0000 0000 0000 0000 0000  ................
0x7ffc83675b70  0000 0000 0000 0000 d358 832b 4e7f 0000  .........X.+N...
0x7ffc83675b80  38b6 812b 4e7f 0000 e747 2800 0000 0000  8..+N....G(.....
0x7ffc83675b90  0000 0000 0000 0000 0000 0000 0000 0000  ................
0x7ffc83675ba0  0000 0000 0000 0000 f011 b16a 2656 0000  ...........j&V..
0x7ffc83675bb0  d05b 6783 fc7f 0000 1e12 b16a 2656 0000  .[g........j&V..
[0x56266ab110e3]> 
```

`CTFlearn` was just moved onto the stack. <br />

This process of loading strange hex values into registers, XORing them with other values, then MOVing the result into the stack continues, I'm not going to go over every single event, as we can set a breakpoint ahead to see the entire flag in memory. <br />

The flag seems like it will be complete around `0x56266ab11168`, as thats where we call some unknown function after a lot of XORing and MOVing onto `rsp`: <br />
```
[0x56266ab110e3]> db 0x56266ab11168
[0x56266ab110e3]> dc
hit breakpoint at: 56266ab11168
[0x56266ab11168]> px 32 @ rsp
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffc83675ac0  4354 466c 6561 726e 7b45 7965 5f4c 3076  CTFlearn{Eye_L0v
0x7ffc83675ad0  655f 4963 656c 616e 645f 7d00 2656 0000  e_Iceland_}.&V..
[0x56266ab11168]> 
```

There's our flag loading into memory, now let's run the program with it as our argument: <br />
```
$ ./Reykjavik CTFlearn{Eye_L0ve_Iceland_}
Welcome to the CTFlearn Reversing Challenge Reykjavik v2: CTFlearn{Eye_L0ve_Iceland_}
Compile Options: ${CMAKE_CXX_FLAGS} -O0 -fno-stack-protector -mno-sse

Congratulations, you found the flag!!: 'CTFlearn{Eye_L0ve_Iceland_}'

```

Our flag is `CTFlearn{Eye_L0ve_Iceland_}` <br />

*You can decrypt the `.enc` file with* `openssl aes-256-cbc -pbkdf2 -d -in sources.zip.enc -out sources.zip`, enter the flag as the `password` <br />



