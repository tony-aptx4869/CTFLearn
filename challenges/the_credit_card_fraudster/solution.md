# [The Credit Card Fraudster](https://ctflearn.com/challenge/970) (20)
Reading the challenge text, we learn two pieces of important info: <br />
- Acceptance of any transaction with a card number multiple of 123457 <br />
- AND the *Luhn check digit is valid*.

We also get the following text, from a receipt: <br />
```
The little flower shop
======================

European Express Debit
Card Number: 543210******1234
SALE

Please debit my account
Amount: 25.00€
```
We can infer the card number used was `543210******1234`, and we know the flag is in the format `CTFlearn{card_number}` <br />

Researching the [Luhn algorithm](https://www.youtube.com/watch?v=PNXXqzU4YnM) we find that it's used to verify credit card numbers. <br />
The steps are as follows: <br />
1. Compute a weighted sum by multiplying every even indexed digit by 2, starting at index 0
2. If multiplying a digit would give you a 2 digit number, you would add each digit of the product. (See example)
3. Add up all of the results, if the sum ends in 0, the string of digits is valid.

**Example**: <br />
3379 5135 6110 8795 <br />
```
3 * 2 =               6
                      3
7 * 2 = 14 -> 1 + 4 = 5
                      9

5 * 2 = 10 -> 1 + 0 = 1
                      1
3 * 2 =               6
                      5

6 * 2 = 12 -> 1 + 2 = 3
                      1
1 * 2 =               2
                      0

8 * 2 = 16 -> 1 + 6 = 7
                      7
9 * 2 = 18 -> 1 + 8 = 9
                      5

6+3+5+9+1+1+6+5+3+1+1+0+7+7+9+5 = 70
```
Our sum does end in 0, meaning our credit card number is valid. <br />

From here, we need to find a string of digits that is a multiple of 123457 and passes the luhn algorithm. <br />
We know there are 6 digits missing from the card number, so at most there are 1 million card combinations to try. <br />
We can brute force the card number with a python script: <br />
```
def luhncheck(digits_str):
	luhn_sum = 0

	# Iterate over credit card digits
	for i in range(0, 16):
		# If index is even, multiply by 2
		if i % 2 == 0:
			digit = int(digits_str[i])
			product = digit*2
			
			# If product is 2 digits, add their sum to sum
			if(product >= 10):
				luhn_sum += int(str(product)[0]) + int(str(product)[1])
			# Otherwise add product to sum
			else:
				luhn_sum += product

		# If index is odd, we add the digit to sum
		else:
			luhn_sum += int(digits_str[i])

	# Determine if sum is valid.
	if(str(luhn_sum)[-1] == '0'):
		return True
	return False

# At most we have 1000000 options (000000 - 999999)
for n in range(0, 1000000):
	padding_zeros = 6 - len(str(n)) # Zeros to pad the left side of insert
	insert = padding_zeros * '0' + str(n) # Digits to replace the ****** chars
	card_num_str = '543210' + insert + '1234' # Create card number
	card_num = int(card_num_str)

	# Perform checks
	if(card_num % 123457 == 0):
		if luhncheck(card_num_str):
			# Print flag
			print("CTFlearn{" + card_num_str + "}")
			exit(0)
```
The output of our script is the flag: `CTFlearn{5432103279251234}` <br />
