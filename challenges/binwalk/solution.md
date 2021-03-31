# [Binwalk](https://ctflearn.com/challenge/108) (30)
Visiting the [link](https://mega.nz/#!qbpUTYiK!-deNdQJxsQS8bTSMxeUOtpEclCI-zpK7tbJiKV0tXYY), we find `PurpleThing.jpeg` <br />
<br />
![Purple Thing](img/PurpleThing.jpeg) <br />
A visual examination reveals nothing. <br />
Running `strings PurpleThing.jpeg` reveals one possible lead: <br />
```
iTXtXML:com.adobe.xmp
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.4.0">
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:exif="http://ns.adobe.com/exif/1.0/">
         <exif:PixelXDimension>802</exif:PixelXDimension>
         <exif:PixelYDimension>118</exif:PixelYDimension>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>

```
Googling [RDF adobe](https://google.com/search?q=RDF+adobe), we can find that it relates to xmp, created by adobe for metadata purposes. <br />
[Exif](https://en.wikipedia.org/Exif) data reveals `PixelXDimension`, `PixelYDimension` relating to the values `802` and `118` respectively. <br />
The image itself however has a resolution of 780x720. <br />
`exif PurpleThing.jpeg` outputs that the image is corrupted <br />
An online metadata analyzer reveals extra data behind the PNG IEND, viewing it with `cat PurpleThing.jpeg` it seems to be a few irrelevant bytes <br />

Googling the name of the challenge *Binwalk*, reveals the `binwalk` tool, used to extract files embedded in binary images. <br />
```
$ binwalk PurpleThing.jpeg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 780 x 720, 8-bit/color RGBA, non-interlaced
41            0x29            Zlib compressed data, best compression
153493        0x25795         PNG image, 802 x 118, 8-bit/color RGBA, non-interlaced
156776        0x26468         Unix path: /www.w3.org/1999/02/22-rdf-syntax-ns#">

```
We wee the image itself, along with Zlib compressed data, which I believe to be the `PurpleThing.jpeg` data. <br />
But something interesting is a PNG image with the dimensions we saw in `strings`, 802 x 118. <br />
Running `binwalk -e PurpleThing.jpeg` to extract the files creates a directory with an empty file called `29` and another zlib compressed file called `29.zlib`<br />
Uncompressing with `zlib-flate -uncompress < 29.zlib > out` reveals nothing by using `strings out` or `cat out` <br />
Viewing `out` as an image reveals a tiny white square with nothing in it. <br />

As it turns out `binwalk`s `-e` option isn't extracting all files. The zlib is also the PNG data for the original image as I believed. <br />
Solution: Either use `foremost PurpleThing.jpeg`, a similar program, or `binwalk -e --dd=".*" PurpleThing.jpeg`, which will extract **all** embedded files. <br />
The flag will be in one of the png outputs from `foremost`, it's `ABCTF{b1nw4lk_is_us3ful}` <br />
