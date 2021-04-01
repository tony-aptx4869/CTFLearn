# [Tux!](https://ctflearn.com/challenge/973) (20)
Upon downloading the [image](https://ctflearn.com/challenge/download/973) we are presented with: <br />
![Penguin](img/Tux.jpg) <br />
Using `strings Tux.jpg | less` we find no flag but there are two interesting strings: <br />
```
ICAgICAgUGFzc3dvcmQ6IExpbnV4MTIzNDUK
%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz
flagUT
```
Running the base64 string through a decoder we find: `Password: Linux12345` <br />

The flag is not `Linux12345`, and the image doesn't require any sort of password, let's check to see if this image has any files embedded inside: <br />
```
$ foremost Tux.jpg

------------------------------------------------------------------
File: Tux.jpg
Start: Wed Mar 31 20:09:03 2021
Length: 5 KB (5703 bytes)
 
Num	 Name (bs=512)	       Size	 File Offset	 Comment 

0:	00000000.jpg 	       5 KB 	          0 	 
1:	00000010.zip 	      63 KB 	       5488 	 
Finish: Wed Mar 31 20:09:03 2021

2 FILES EXTRACTED
	
jpg:= 1
zip:= 1
------------------------------------------------------------------
```

The zip is almost definitely what requires a password. <br />
Open it like this: <br />
```
$ unzip 00000010.zip 
Archive:  00000010.zip
[00000010.zip] flag password: 
 extracting: flag                    
$ ls
00000010.zip  flag
cat flag
CTFlearn{Linux_Is_Awesome}
```
the `flag` file contains our flag: `CTFlearn{Linux_Is_Awesome}` <br />
