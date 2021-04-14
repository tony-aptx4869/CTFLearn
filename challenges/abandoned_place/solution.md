# [abandoned place](https://ctflearn.com/challenge/1000) (30)
Downloading the [image](https://ctflearn.com/challenge/download/1000), we are presented with: <br />
![Abandoned Street](img/abondoned_street_challenge2.jpg) <br />

First we have to look at the dimensions like the challenge text states, but `exif` finds no data: <br />
```
$ exif abondoned_street_challenge2.jpg 
Corrupt data
The data provided does not follow the specification.
ExifLoader: The data supplied does not seem to contain EXIF data.
```

`cat` doesn't reveal any readable text, and neither does the `strings`, but the image is openable, so the programs opening this `.jpg` file must know the dimensions somehow. To find the dimensions of the image, we have to do some research on `.jpg`'s file format. <br />

`.jpg`'s format doesn't have any specifications on resolution in it's header, only pixel density, apparently you can still get the resolution though through the `FFC0` tag, our jpg is `2016` pixels in width and `900` pixels in height. See [this](https://www.quora.com/How-do-I-extract-width-and-height-data-from-an-Exif-JPG-hex-format-in-C++) for the breakdown on the `FFC0` tag, how we we're supposed to find this information is anyone's guess. <br />

That however is not enough, for some reason we must come to the conclusion that we must change the jpg height and width to `2016`x`2016`, why? - I have absolutely no idea how the challenge creator thought anyone would think this is how we get to the flag. <br />

By modifying the hex values for the image dimensions in a hex editor to both be `07e0`, we're able to set the image resolution to `2016`x`2016`, and upon viewing the image again, we have our flag. <br />

Flag: `urban_exporation`

