# [Adoni Assembler Chall](https://ctflearn.com/challenge/1026) (10)
Like the challenge text states, we have the assembler source code, but have to change it in order to get the flag. The flag is also related to *Adoni*, a city in India. <br />

Downloading the [file](https://ctflearn.com/challenge/download/1026), we can `unzip` it and are then presented with two files, `adoni.asm` and `readme`. We can display the readme with `cat`: <br />
```
$ cat readme
Welcome to the CTFLearn Adoni Assembler Programming Challenge

This Challenge is designed as an entry level 64 bit assembler programming challenge for someone who has never
done any Assembler programming previously.

==========================================================================
How to solve this challenge:
Modify the assembler source adoni.asm so that the flag is written to the screen (stdout)

There are multiple ways to get the flag for this challenge, but if you are new to assembler the intent is for you to
modify the adoni.asm source file, compile, link and run it to see the flag.

Compiling and linking instructions for adoni.asm are provided in the YouTube videos below.

The videos below provide an introduction to 64 bit Assembler programming on Intel CPU's.

============================================================================

This challenge uses the NASM compiler: https://www.nasm.us/

There are lots of videos and resources on the Internet for learning assembler.  These are the ones that I used as a
basis for building this challenge (and I'm planning on following the same approach for future Assembler
challenges).

LiveOverflow on YouTube is an excellent resource and this video is a good place to start if
you do not know assembler: (not required but recommended)
https://www.youtube.com/watch?v=6jSKldt7Eqs

This challenge (and the next few also) are based on these YouTube videos.
Please watch all the videos if you have never done any Assembly programming.

x86_64 Linux Assembly #1 - "Hello, World!"
https://www.youtube.com/watch?v=VQAKkuLL31g

x86_64 Linux Assembly #2 - "Hello, World!" Breakdown
https://www.youtube.com/watch?v=BWRR3Hecjao

x86_64 Linux Assembly #3 - Jumps, Calls, Comparisons
https://www.youtube.com/watch?v=busHtSyx2-w

=================================================================================================

www.asmtutor.com is also a good website for learning assembler.  However this site is based on
32 bit assembler, and this challenge is a 64 bit challenge.  You can work through asmtutor.com
also to learn assembler because the concepts are the same.

One difference between 32 and 64 bit assembler is that the system call numbers are different.
Here is a table of 64 bit system calls:
https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

====================================================================================================
Adoni is a city in India, more information can be found here:
https://www.britannica.com/place/Adoni
https://en.wikipedia.org/wiki/Adoni

If you would like to learn more about India here is a good resource:
https://www.cia.gov/library/publications/the-world-factbook/geos/in.html
```

Now let's see `adoni.asm`:
```
$ cat adoni.asm
; This is a comment
; CTFlearn Assembly Programming Challenge "Adoni" by kcbowhunter

section .data
    welcome db "Hello CTFlearn Adoni Assembler Challenge!",0x0a
    noflag db "Sorry no flag for you :-(",0x0a
    adoni db 67, 84, 70, 108, 101, 97, 114, 110, 123, 75, 117, 114, 110, 48, 48, 108, 95, 68, 105, 115, 116, 114, 105, 99, 116, 125, 0x0a
    congrats db 67, 111, 110, 103, 114, 97, 116, 115, 44, 32, 121, 111, 117, 32, 102, 111, 117, 110, 100, 32, 116, 104, 101, 32, 102, 108, 97, 103, 33, 0x0a

section .text
    global _start

_start:
    mov rax, 1      ; sys_write system call
    mov rdi, 1      ; stdout (write to screen)
    mov rsi, welcome   ; memory location of string to write
    mov rdx, 42     ; number of characters in string to write
    syscall

    mov rax, 1      ; sys_write system call
    mov rdi, 1      ; stdout
    mov rsi, noflag ; memory location of string to write
    mov rdx, 26     ; number of characters in string to write
    syscall

    mov rax, 60     ; exit system call
    mov rdi, 0
    syscall

;   this is the assembly code to print the flag
_printflag:
    mov rax, 1      ; sys_write system call
    mov rdi, 1
    mov rsi, congrats
    mov rdx, 30
    syscall

    mov rax, 1      ; sys_write system call
    mov rdi, 1
    mov rsi, adoni
    mov rdx, 27
    syscall

    mov rax, 60     ; exit system call
    mov rdi, 0
    syscall
```

Analyzing the code, we find 4 values in the `.data` section, which holds variables: <br />
```
section .data
	welcome db "Hello CTFlearn Adoni Assembler Challenge!",0x0a
	noflag db "Sorry no flag for you :-(",0x0a
	adoni db 67, 84, 70, 108, 101, 97, 114, 110, 123, 75, 117, 114, 110, 48, 48, 108, 95, 68, 105, 115, 116, 114, 105, 99, 116, 125, 0x0a
	congrats db 67, 111, 110, 103, 114, 97, 116, 115, 44, 32, 121, 111, 117, 32, 102, 111, 117, 110, 100, 32, 116, 104, 101, 32, 102, 108, 97, 103, 33, 0x0a
```

`adoni` and `congrats` are both strings like `noflag` and `welcome`, but they are written by ASCII values, I can already tell which one is the flag. <br />

Instead of just decoding the ASCII, (which can be done with [ascii.cl](https://ascii.cl) or `man ascii`), let's modify, compile, and link the asm code using `nasm`. <br />
`_start` denotes the entry point for this program, and it currently prints the `welcome` string and the `noflag` string, let's change this program to run the `_printflag` function instead. We can achieve this by renaming `_start` to `_old_start` and renaming `_printflag` to `_start`, do NOT change the text `global _start`, or the program will have no entry point.<br />

Now we can compile and link (64-bit linux) <br />
```
$ nasm -f elf64 adoni.asm
$ ld -m elf_x86_64 adoni.o -o adoni
```

Running the newly linked program `adoni`, we get the flag in plaintext: <br />
```
$ ./adoni 
Congrats, you found the flag!
CTFlearn{Kurn00l_District}
```

Our flag is `CTFlearn{Kurn00l_District}`
