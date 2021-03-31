# [WOW.... So Meta](https://ctflearn.com/challenge/348) (20)
By downloading the file from the [link](https://mega.nz/file/ifA2QAwQ#WF-S-MtWHugj8lx1QanGG7V91R-S1ng7dDRSV25iFbk) we see the following image: <br />
![Ocean sunset](img/3UWLBAUCb9Z2.jpg) <br />
We have to look at the image metadata, `exif 3UWLBAUCb9Z2.jpg` outputs: <br />
```
EXIF tags in '3UWLBAUCb9Z2.jpg' ('Motorola' byte order):
--------------------+----------------------------------------------------------
Tag                 |Value
--------------------+----------------------------------------------------------
Orientation         |Top-left
X-Resolution        |72
Y-Resolution        |72
Resolution Unit     |Inch
Software            |Photos 1.5
Date and Time       |2014:12:27 16:45:55
Padding             |2060 bytes undefined data
Exif Version        |Exif Version 2.21
Date and Time (Origi|2014:12:27 16:45:55
Date and Time (Digit|2014:12:27 16:45:55
Components Configura|Y Cb Cr -
Light Source        |Tungsten incandescent light
FlashPixVersion     |FlashPix Version 1.0
Color Space         |sRGB
Pixel X Dimension   |4002
Pixel Y Dimension   |1536
Scene Capture Type  |Standard
Sharpness           |Hard
Padding             |2060 bytes undefined data
--------------------+----------------------------------------------------------
```
No flag here, and nothing really interesting either. <br />
By utilizing `strings 3UWLBAUCb9Z2.jpg | less` we find the following interesting chunk of information: <br />
```
<?xpacket begin="
" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.4.0">
	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		<rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/" xmp:CreateDate="2014-12-27T16:45:55" xmp:ModifyDate="2014-12-27T16:45:55" xmp:CreatorTool="Photos 1.5" photoshop:DateCreated="2014-12-27T16:45:55"/>
		<rdf:Description xmlns:MicrosoftPhoto="http://ns.microsoft.com/photo/1.0/"><MicrosoftPhoto:CameraSerialNumber>flag{EEe_x_I_FFf}</MicrosoftPhoto:CameraSerialNumber></rdf:Description></rdf:RDF>
</x:xmpmeta>
```
The line `<MicrosoftPhoto:CameraSerialNumber>flag{EEe_x_I_FFf}</MicrosoftPhoto:CameraSerialNumber>` contains our flag: `flag{EEe_x_I_FFf}`
