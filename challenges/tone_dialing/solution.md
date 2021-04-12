# [Tone dialing](https://ctflearn.com/challenge/889) (30)
The first thing that stands out from the challenge text is all the numbers, `64`, `10`, and `1pm` along with *Later I started thinking about the 24 hour clock.* Which makes `1pm` into `13`. <br />

So we have 3 important numbers: 64, 10, and 13. <br />

Listening to the [.wav file](https://ctflearn.com/challenge/download/889), we hear a few dial tones like the challenge text suggests, appears all of different pitch and mostly 2 beeps. Although some have 3. <br />

Anaylzing the .wav file with `xxd`, we find large chunks of `0x80` bytes, which I believe to be the data for silence between dial tone beeps. <br /> 

I analyzed the .wav with a spectrogran analysis tool and wrote down the number of beeps per tone: <br />
`2 2 2 3 3 2 3 3 2 2 2 2 2 2 2 2 2 2 2 2 3` <br />
This code does not appear to be morse code either. <br />

After thinking about the important numbers for a while, I thought of the `64` being related to `base64` and the `13` being related to `rot13`. <br />
I continued to do a lot of searching with `xxd` and found absolutely nothing useful. <br />

Googling "Tone dialing", we're able to find a wikipedia article titled [Dual-tone multi-frequency signaling](https://en.wikipedia.org/wiki/Dual-tone_multi-frequency_signaling). Under the *Keypad* header, there is a table showing the relationship between two frequencies and their associated value. <br />
By running the .wav file through a [spectrogram analysis tool](https://academo.org/articles/spectrogram/), we're able to visualize the tone dialing audio. <br />
![Spectrogram](img/spectrogram) <br />
Each *beep* has two tones associated with it, which are denoted by the yellow lines. The tone of lower frequency is tone A, and the tone above is tone B. We can use the keypad table on wikipedia to manually decode this, but it's a tricky without a 0-2kHz scale. <br />
I decoded the first 4 beeps of the spectrogram, and they resolve to `6 7 8 4`, since the beeps are in pulses of 2 or 3, by associating the digits with their respective pulses we get `67 84` - ascii for `CT`, looks like we're decoding a flag. <br />

Instead of doing the whole thing manually, we can use a python script found [here](https://github.com/ribt/dtmf-decoder) to automate this process: <br />
```
$ git clone https://github.com/ribt/dtmf-decoder.git
$ cd dtmf-decoder/
$ python3 -m pip install -r requirements.txt --upgrade
$ python3 dtmf.py /path/to/you_know_what_to_do.wav
67847010810197110123678289808479718265807289125
``` 

Using the output `67847010810197110123678289808479718265807289125` we can separate the ascii values by the pulses on the spectrogram, 2 pulses being a 2 digit ascii value and 3 pulses being a 3 digit ascii value: <br />
`67 84 70 108 101 97 110 123 67 82 89 80 84 79 71 82 65 80 72 89 125` <br />

Ascii character representations of these values: <br />
`CTFlea n{CRYPTOGRAPHY}` <br />
Looks like the program left out the `r` or maybe it wasn't included in the first place. <br />
Entering the flag with the `r` included anyway is successful: <br />
Our flag is `CTFlearn{CRYPTOGRAPHY}` <br />
