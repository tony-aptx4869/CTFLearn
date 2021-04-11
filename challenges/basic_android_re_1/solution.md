# [Basic Android RE 1](https://ctflearn.com/challenge/962) (10)
This challenge gives us an [apk file](https://ctflearn.com/challenge/download/962) for download, APK files are actually renamed zip files, so we can use `unzip` to extract the contents. However the challenge text implies we need to reverse engineer part of the code, so more analyze will be required than a simply look at the apk contents. <br />

We can use `apktool` a commandline tool for analyzing apks on linux, use `apktool d BasicAndroidRE1.apk` to **d**ecode the apk into a subdirectory. <br />

Navigating into the new directory, we find the following files: <br />
```
$ ls -p
AndroidManifest.xml  apktool.yml  original/  res/  smali/  unknown/
```

The first directory that stands out is `smali/`. `.smali` files are used by the smali/baksmali assembler/disassembler for the dex format used by dalvik, Android’s Java VM implementation. This folder essentially contains the disassembly of the apk binaries. <br />

Inside `smali/` we find `MainActivity.smali`, giving it an thorough read with `bat` I found a few interesting lines. <br />
```
.method public submitPassword(Landroid/view/View;)V

(...)

invoke-static {v0}, Lorg/apache/commons/codec/digest/DigestUtils;->md5Hex

(...)

const-string v1, "b74dec4f39d35b6a2e6c48e637c8aedb"

(...)

invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

(...)

const-string v2, "Success! CTFlearn{"

(...)

const-string p1, "_is_not_secure!}"

```

From this smali code, we can infer that our flag will look something like `CTFlearn{` ... `_is_not_secure!}` <br />
We also know that something is being hashed with md5, and appears to be compared to the md5 hash `b74dec4f39d35b6a2e6c48e637c8aedb` <br />

In an attempt to quickly determine what input string gives the output `b74dec4f39d35b6a2e6c48e637c8aedb`, I visited a few hash database websites and attempted to find `b74dec4f39d35b6a2e6c48e637c8aedb`. On my third website, [hashes.com](https://hashes.com/en/decrypt/hash), I was able to get a match: `b74dec4f39d35b6a2e6c48e637c8aedb:Spring2019` <br />

Verifying the match with md5sum: `echo -n "Spring2019" | md5sum` outputs the exact same hexadecimal. <br />

We're on the right track, could the flag be an insertion of `Spring2019`?

Entering our guess on ctflearn, we are successful. Our flag: `CTFlearn{Spring2019_is_not_secure!}` <br />

*You could also crack an md5 hash with:* `hashcat -m 0 b74dec4f39d35b6a2e6c48e637c8aedb` <br />
*You will probably need a beefy dedicated gpu for time efficiency* <br />
