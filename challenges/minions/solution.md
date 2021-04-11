# [Minions](https://ctflearn.com/challenge/955) (20)
Downloading the [file](https://mega.nz/file/1UBViYgD#kjKISs9pUB4E-1d79166FeX3TiY5VQcHJ_GrcMbaLhg), we are presented with an image: <br />
![Minion with guitar](img/Hey_You.png) <br />
Analyzing the png with the `strings` command reveals a large chunk of strings after the `IEND` of the png: <br />
```
IEND
Rar!
$You_Still_Here/Nothing_Here_16/..txt
Ac]I
https://mega.nz/file/wZw2nAhS#i3Q0r-R8psiB8zwUrqHTr661d8FiAS1Ott8badDnZkoH
You_Still_Here/Nothing_Here_1
You_Still_Here/Nothing_Here_10
You_Still_Here/Nothing_Here_11
You_Still_Here/Nothing_Here_12
You_Still_Here/Nothing_Here_13
You_Still_Here/Nothing_Here_14
You_Still_Here/Nothing_Here_15
You_Still_Here/Nothing_Here_16
You_Still_Here/Nothing_Here_17
You_Still_Here/Nothing_Here_18
You_Still_Here/Nothing_Here_19
You_Still_Here/Nothing_Here_2
You_Still_Here/Nothing_Here_3
You_Still_Here/Nothing_Here_4
You_Still_Here/Nothing_Here_5
You_Still_Here/Nothing_Here_6
You_Still_Here/Nothing_Here_7
You_Still_Here/Nothing_Here_8
You_Still_Here/Nothing_Here_9
You_Still_Here
```
We find a [mega link](https://mega.nz/file/wZw2nAhS#i3Q0r-R8psiB8zwUrqHTr661d8FiAS1Ott8badDnZkoH) and what look to be file paths. <br />
Trying to extract any hidden embedded files with `foremost` reveals nothing. <br />

Visiting the link we are presented with: <br />
![Minion wearing crown](img/Only_Few_Steps.jpg) <br />
Running `strings Only_Few_Steps.jpg` we find one string of note: `YouWon(Almost).jpg` <br />
`foremost` finds nothing to extract from the image. <br />
`binwalk` finds nothing useful to extract from the image: <br />
```
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
30            0x1E            TIFF image data, little-endian offset of first image directory: 8
426           0x1AA           Copyright string: "Copyright (c) 1998 Hewlett-Packard Company"
```

<hr />

There really wasn't much else I could do here, `binwalk`, `foremost`, `exif`, `xxd`, all revealed nothing. I googled the solution and apparently `binwalk` is to be used to find a RAR file embedded in this second image. I assume either the image has since been modified or binwalk was changed and for some reason no longer finds the RAR file. <br />

If you are to run `strings` on the extracted image, you would find: `CTF{VmtaU1IxUXhUbFZSYXpsV1RWUnNRMVpYZEZkYWJFWTJVVmhrVlZGVU1Eaz0=)` <br />
The base64 decodes into `M1NI0NS_ARE_C00L` <br />

This means the flag is `CTFlearn{M1NI0NS_ARE_C00L}` <br />
