# [Exif](https://ctflearn.com/challenge/303) (20)
Downloading the file at the [link](https://mega.nz/#!SDpF0aYC!fkkhBJuBBtBKGsLTDiF2NuLihP2WRd97Iynd3PhWqRw), we find the following image: <br />
![Password surrounded by binary data](img/Computer-Password-Security-Hacker - Copy .jpg) <br />
<br />
Running `exif` on the image, we get the following:
```
EXIF tags in 'Computer-Password-Security-Hacker - Copy.jpg' ('Motorola' byte order):
--------------------+----------------------------------------------------------
Tag                 |Value
--------------------+----------------------------------------------------------
Resolution Unit     |Internal error (unknown value 1)
YCbCr Positioning   |Centered
X-Resolution        |72
Y-Resolution        |72
Exif Version        |Unknown Exif Version
Components Configura|Y Cb Cr -
FlashPixVersion     |FlashPix Version 1.0
Color Space         |Internal error (unknown value 65535)
North or South Latit|S
Latitude            |77, 17, 2.61894
East or West Longitu|E
Longitude           |44,  4, 7.3047
--------------------+----------------------------------------------------------
```
The EXIF data has some interesting fields, some of which seem to have been edited with invalid values, along with Latitude and Longitude data for an image that wouldn't be expected to have those. <br />
<br />
Running `strings` on the image reveals the flag: `flag{3l1t3_3x1f_4uth0r1ty_dud3br0}` <br />
It seems like the exif tools aren't the best at grabbing a flag from an image file <br />
