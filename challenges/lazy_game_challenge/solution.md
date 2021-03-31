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
Now we have a piece of information on how the serverside code handles things, we  know the server is programmed in python, and we see that our bet is stored in the variable `spent` <br />
<br />
I was able to increase my balance on a loss by entering a negative integer when placing a bet: <br />
```
(placed bet of -1000)

Sorry you didn't made it !
Play Again !...
Better Luck next Time !.
Sorry you lost some money !..
Your balance has been updated !.
Current balance :  : 
1500$
```
<br />
I was able to win a jackpot by guessing the correct number, but when betting -1000000 it caused my balance to be displayed as negative: <br />
```
You made it !.
You won JACKPOT !..
You thought of what computer thought !.
Your balance has been updated !

Current balance : -100500$
Want to play again? Y/N : 
```
<br />
Placing a bet with an extremely large negative number causes an immediate server disconnect: <br />
```
Money you have : -1999500$
Place a Bet : -10000000000000000000000000000000000000000000000000000000000000000000

(disconnected)
```
<br />
**What we've learned**:
If you bet with a negative number and win, your account balance will decrease. <br />
We know that we can bet numbers **less than** our balance, and if we win, our balance has our bet added to it. <br />
It seems best to enter a bet with a negative number, lose, and see your account balance increase. <br />

Therefore, to get to an account balance of over `$1000000`, we need to bet at most `-999501` and lose. <br />
We can ensure a loss by guessing 0 everytime. <br />
```
Sorry you didn't made it !
Play Again !...
Better Luck next Time !.
Sorry you lost some money !..
Your balance has been updated !.
Current balance :  : 
1000500$
What the... how did you get that money (even when I tried to stop you)!? I guess you beat me!

The flag is CTFlearn{d9029a08c55b936cbc9a30_i_wish_real_betting_games_were_like_this!}

Thank you for playing ! 
Made by John_123
Small mods by theKidOfArcrania
Give it a (+1) if you like !..
```

By reaching a balance over 1 million, we get the flag: `CTFlearn{d9029a08c55b936cbc9a30_i_wish_real_betting_games_were_like_this!}`
