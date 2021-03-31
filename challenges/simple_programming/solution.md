# [Simple Programming](https://ctflearn.com/challenge/174) (30)
Downloading the file from the [link](https://mega.nz/file/7aoVEKhK#BAohJ0tfnP7bISIkbADK3qe1yNEkzjHXLKoJoKmqLys) gives us `data.dat` <br />
It contains a 10000 lines of binary data, the challenge wants us to determine: <br />
> the number of 0's is a multiple of 3 or the numbers of 1s is a multiple of 2. <br />
We can write a python script to take care of this:
```
hits = 0
with open("data.dat", "r") as f:
	line = f.readline()

	while line != "":
		if line.count('0') % 3 == 0:
			hits += 1
		elif line.count('1') % 2 == 0:
			hits += 1
		line = f.readline()

print(hits)
```
Run the script in the same directory as `data.dat` with:
`$ python3 script.py`
Our flag will be written to stdout: `6662`
