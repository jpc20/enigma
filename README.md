# Enigma

## Back End Mod 1 Final Project

### Description

Ruby program designed to encyrpt text, decrypt text, and crack the encryption algorithm.  

The encrypt method takes a message String as an argument. It can optionally take a Key and Date as arguments to use for encryption. 
If the key is not included, it will generate a random key. If the date is not included, it will use today’s date. 
 
The decrypt method takes a ciphertext String and the Key used for encryption as arguments. The decrypt method can optionally take a date as the third argument. 
If no date is given, it uses today’s date for decryption.  
  
The crack method takes 3 arguments. The first is an existing file that contains an encrypted message. The second is a file path where the program writes the cracked message.
The third is the date to be used for cracking. In addition to writing the cracked message to the file, 
it outputs to the screen the file it wrote to, the key used for cracking, and the date used for cracking.

#### Areas of Focus

* Practice breaking a program into logical components
* Build classes that demonstrate single responsibilities
* Test drive a well-designed Object Oriented solution
* Work with file i/o

## Getting Started
### Prerequisites
```javascript
brew install ruby -2.5.3
gem install mocha
```
### Installing
#### Clone repository:
```javascript
git clone git@github.com:jpc20/enigma.git
```
#### Navigate into directory:
```javascript
cd enigma
```

#### Run test suite:
```javascript
rake
```

#### Encrypyt, Decrypt, and Crack from the command line:
```javascript
ruby ./lib/encrypt.rb message.txt encrypted.txt
ruby ./lib/decrypt.rb encrypted.txt decrypted.txt 82648 240818
ruby ./lib/crack.rb encrypted.txt cracked.txt 240818
```
