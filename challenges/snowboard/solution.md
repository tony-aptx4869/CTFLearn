# [Snowboard](https://ctflearn.com/challenge/934) (20)
By downloading the [image](https://ctflearn.com/challenge/download/934) we are presented with the following: <br />
![Snowboard](img/Snowboard.jpg) <br />
Running `strings Snowboard.jpg | less` we find the flag. <br />
But the flag isn't `CTFlearn{CTFIsEasy!!!}`, it's actually the base64 encoded string beneath it. <br />
We can get the flag with `echo "Q1RGbGVhcm57U2tpQmFuZmZ9Cg==" | base64 -d ` <br />
The flag is `CTFlearn{SkiBanff}` <br />
