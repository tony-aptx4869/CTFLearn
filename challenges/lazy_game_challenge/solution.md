# [Lazy Game Challenge](https://ctflearn.com/challenge/691) (30)
Let's connect to the server with `nc thekidofarcrania.com 10001` <br />
Here's what we see: <br />
```
Welcome to the Game of Luck !. 

Rules of the Game :
(1) You will be Given 500$
(2) Place a Bet
(3) Guess the number what computer thinks of !
(4) computer's number changes every new time !.
(5) You have to guess a number between 1-10
(6) You have only 10 tries !.
(7) If you guess a number > 10, it still counts as a Try !
(8) Put your mind, Win the game !..
(9) If you guess within the number of tries, you win money !
(10) Good Luck !..

theKidOfArcrania:
  I bet you cannot get past $1000000!


Are you ready? Y/N : 
```
I'm not taking a very strict approach to this challenge, just messing around with it to see if anything breaks, called fuzzing. <br />
<br />
I was able to get the server to display an error message by giving it strange input: <br />
```
Money you have : 500$
Place a Bet : (1 * (-500))     
Traceback (most recent call last):
  File "/server.py", line 57, in <module>
    spent = int(input('Place a Bet : '))
ValueError: invalid literal for int() with base 10: '(1 * (-500))'
```
Now we have a piece of information on how the serverside code handles things, now we can mess with abusing the `int(input())` function in python <br />
