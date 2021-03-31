# [I'm a dump](https://ctflearn.com/challenge/883) (10)
`strings file | less` reveals the flag split across 3 different strings, and with **H** interwoven in it <br />
```
(strings excerpt)

CTFlearnH
{fl4ggyfH
l4g}H
```
Simply remove the occurances of **H** <br />
flag: `CTFlearn{fl4ggyfl4g}` <br />
<br />
I think what the author was going for was more analysis, the file is an executable and a disassembly of `main` reveals some interesting hex values: <br />
```
            ;-- main:
/ (fcn) sym.main 98
|   sym.main ();
|           ; var int local_30h @ rbp-0x30
|           ; var int local_28h @ rbp-0x28
|           ; var int local_20h @ rbp-0x20
|           ; var int local_18h @ rbp-0x18
|           ; var int local_10h @ rbp-0x10
|           ; var int local_8h @ rbp-0x8
|              ; DATA XREF from 0x00001061 (entry0 + 33)
|           0x00001139      55             push rbp
|           0x0000113a      4889e5         mov rbp, rsp
|           0x0000113d      4883ec30       sub rsp, 0x30               ; '0'
|           0x00001141      64488b042528.  mov rax, qword fs:[0x28]    ; [0x28:8]=0x3970 ; '('
|           0x0000114a      488945f8       mov qword [local_8h], rax
|           0x0000114e      31c0           xor eax, eax
|           0x00001150      48b84354466c.  movabs rax, 0x6e7261656c465443
|           0x0000115a      48ba7b666c34.  movabs rdx, 0x66796767346c667b
|           0x00001164      488945d0       mov qword [local_30h], rax
|           0x00001168      488955d8       mov qword [local_28h], rdx
|           0x0000116c      48c745e06c34.  mov qword [local_20h], 0x7d67346c
|           0x00001174      48c745e80000.  mov qword [local_18h], 0
|           0x0000117c      48c745f00000.  mov qword [local_10h], 0
|           0x00001184      90             nop
|           0x00001185      488b45f8       mov rax, qword [local_8h]
|           0x00001189      644833042528.  xor rax, qword fs:[0x28]
|       ,=< 0x00001192      7405           je 0x1199
|       |   0x00001194      e897feffff     call sym.imp.__stack_chk_fail ; void __stack_chk_fail(void)
|       |      ; JMP XREF from 0x00001192 (sym.main)
|       `-> 0x00001199      c9             leave
\           0x0000119a      c3             ret

```
*0x6e7261656c465443* <br />
*0x66796767346c667b* <br />
*0x7d67346c* <br />
Decoded, they spell the flag backwards. <br />
