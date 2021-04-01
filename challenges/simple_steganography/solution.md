# [Simple Steganography](https://ctflearn.com/challenge/894) (30)
Upon downloading the [image](https://ctflearn.com/challenge/download/894) we are presented with: <br />
![Minions](img/Minions1.jpeg) <br />
> hint-" Steghide Might be Helpfull" <br />

`exif` finds nothing, `file` finds nothing relevant, `strings` finds an interesting string: `myadmin` <br />
Reading the [documentation](http://steghide.sourceforge.net/documentation.php) for `steghide`, we find that it's a program used to embed and retreive data from an image, and depends on a password <br />
With the password `myadmin`, we're able to get the flag. <br />
```
$ steghide extract -sf Minions1.jpeg 
Enter passphrase: 
wrote extracted data to "raw.txt".
$ cat raw.txt 
AEMAVABGAGwAZQBhAHIAbgB7AHQAaABpAHMAXwBpAHMAXwBmAHUAbgB9

$ cat raw.txt | base64 -d
CTFlearn{this_is_fun}
```
With that, we have our flag: `CTFlearn{this_is_fun}` <br />
