# Off-chain signing using Ethereum keys

This little utility help you make build a Ethereum based key-pair.  With this
key you can sign messages that people can verify by just using your public key.

All commands are wrapped in a Makefile. You require the following:

* docker 18.03 or better
* GNU Make 3.81 or better

Signing binary files requires keccak-256sum to be installed. Please build and
install the following packages from source:

[git@github.com:maandree/libkeccak.git](git@github.com:maandree/libkeccak.git)

[git@github.com:maandree/sha3sum.git](git@github.com:maandree/sha3sum.git)

## Build your key
make -s build key export PASSWD="**< YourPasswd >**"

## Start with existing key
make -s build import

## Signing
make -s signature MESSAGE="HELLOWORLD" PASSWD="**< YourPasswd >**"

## Verify
make -s verify MESSAGE="HELLOWORLD" SIGNATURE="**< SignatureOf-HELLOWORLD >**"

## Signing a binary file
make -s signbin FILE="**< FullPathAndFilename >**" PASSWD="**< YourPasswd >**"

## Verifying a binary file
make -s verifybin FILE="**< FullPathAndFilename >**" SIGNATURE="**< SignatureOf-BinaryFile >**"
