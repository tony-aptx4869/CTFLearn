# [Taking LS](https://ctflearn.com/challenge/103) (30)
By checking out the [link](https://mega.nz/#!mCgBjZgB!_FtmAm8s_mpsHr7KWv8GYUzhbThNn0I8cHMBi4fJQp8), we find `'The Flag.zip'` which can be downloaded and unzipped with `unzip`. <br />
In it we find two directories, `__MACOSX` and `'The Flag'`. <br />
The `__MACOSX` directory appears to be just metadata, but `'The Flag'` contains `'The Flag.pdf'` <br />
If we attempt to open the pdf, it requires a password. <br />
Running strings on files in both the `__MACOSX` and `'The Flag'` folders doesn't yield anything useful. <br />
After some research the `__MACOSX` folder doesn't seem to be relevant, as it's marking the pdf as [quarantined](https://apple.stackexchange.com/questions/104712/what-causes-os-x-to-mark-a-folder-as-quarantined). <br />

Turns out I never did `ls -al` on `'The Flag'` directory itself, which contains `.ThePassword/`, I had ignored all the hints at using `ls`. <br />
Inside `.ThePassword/` is `ThePassword.txt`. <br />
`$ cat ThePassword.txt` outputs: <br />
`Nice Job!  The Password is "Im The Flag".` <br />
Now we can open the PDF and the flag `ABCTF{T3Rm1n4l_is_C00l}` is displayed inside. <br />
