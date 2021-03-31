# [My Blog](https://ctflearn.com/challenge/979) (20)
Viewing the [Noxtal.com](https://noxtal.com) page as source, ctrl+f for flag reveals nothing<br />
[robots.txt](https://noxtal.com/robots.txt) reveals a [sitemap](https://noxtal.com//sitemap.xml) which we can use to locate every page.<br />
The challenge text speaks of an **application** for your **memory**, hitting F12 and navigating to the memory usage tab reveals nothing important. <br />
However, navigating to the `Application` tab then expanding `Local Storage` reveals the flag: `flag{n7f_l0c4l_570r463_15n7_53cur3_570r463}`<br />
Which we replace with `CTFlearn{n7f_l0c4l_570r463_15n7_53cur3_570r463}` <br />

