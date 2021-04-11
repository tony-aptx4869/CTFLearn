# [The Credit Card Fraudster](https://ctflearn.com/challenge/970) (20)
I just arrested someone who is probably the most wanted credit card fraudster in Europe. She is a smart cybercriminal, always a step ahead INTERPOL and she kept unnoticed for years by never buying online, but buying goods with a different card every time and in different stores. My cyber-analysts found out after collecting all evidences she hacked into one the largest payment provider in Europe, reverse-engineered the software present on the server and partly corrupted the card number validation code to accept all her payments. The change enables acceptance of any transaction with a card number multiple of 123457 and the Luhn check digit is valid. <br />

I caught her because every year she bought a bouquet of flowers next to the same cemetery. While handcuffing her at the flower shop's exit, she said the flowers were for her lost father and today it is his death anniversary. She broke down in tears and she did some steps and threw something in the sewers. My female colleague conducted a search on her, but she couldn't find the card she used, only the receipt. <br />

```
The little flower shop
======================

European Express Debit
Card Number: 543210******1234
SALE

Please debit my account
Amount: 25.00€
```
Can you help me to recover the card number so that I can confirm with the flower merchant's bank the card number was used in that shop and is fraudulent? <br />

Hints: <br />

1/ [Luhn_algorithm](https://www.youtube.com/watch?v=PNXXqzU4YnM) <br />

2/ Flag format is `CTFlearn{card_number}` <br />
