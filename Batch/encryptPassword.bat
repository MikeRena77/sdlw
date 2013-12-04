rem This is the form for using the gpg command that encrypts a file
rem --here name ReadMe.txt for the example-- and generates a new
rem encrypted file ReadMe.txt.gpg which you can furnish without fear
rem  of intermediate decryption
rem  Running this command will require the keyOwner's passphrase 
rem Usage:  gpg -se -r keyOwner fileName

gpg -se -r "Michael Andrews" ReadMe.txt