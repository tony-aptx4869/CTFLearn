# [Chalkboard](https://ctflearn.com/challenge/972) (30)
Downloading the [image](https://ctflearn.com/challenge/download/972) presents us with the following: <br />
![Chalkboard](img/math.jpg) <br />
Since the challenge text tells us there are images embedded in this image, I tried to use foremost to extract them, but it revealed no emedded images. <br />
Running `strings math.jpg | less` reveals: <br />
```
The flag for this challenge is of the form:
CTFlearn{I_Like_Math_x_y}
where x and y are the solution to these equations:
3x + 5y = 31
7x + 9y = 59
```
<br />
I solved the system of equations by just looking at it and guessing, because I don't remember high school algebra, but x=2 and y=5 <br />
This means our flag is: `CTFlearn{I_Like_Math_2_5}` <br />
