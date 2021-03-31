# [PikesPeak](https://ctflearn.com/challenge/935) (20)
Upon downloading the [image](https://ctflearn.com/challenge/download/935), we see the following: <br />
![Pike's Peak](img/PikesPeak.jpg) <br />
Running `strings PikePeak.jpg | less` we find a few flags:
```
CTFLEARN{PikesPeak}
CTFLearn{Colorado}
%ctflearn{MountainMountainMountain}
#cTfLeArN{CTFMountainCTFmOUNTAIN}
CTF{AsPEN.Vail}
CTFlearn{Gandalf}
ctflearning{AUCKLAND}
ctfLEARN{MtDoom}
6ctflearninglearning{Mordor.TongariroAlpineCrossing}
+CTFLEARN{MountGedePangrangoNationalPark}
$ctflearncTfLeARN{MountKosciuszko}
```
Valid flags start with *CTFlearn*, therefore the correct flag is `CTFlearn{Gandalf}` <br />
