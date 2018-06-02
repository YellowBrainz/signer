# Off-chain signing using Ethereum keys

This little utility help you make build an Ethereum based key-pair With the
private key you can sign messages that people can verify by just using your
public key, and the message.

In this folder you find the following files:
+
|-- Dockerfile
|-- docs
|   +-- somefile.pdf
|-- keystore
|   +-- pw
|   +-- UTC--2018-06-02T16-59-15.641342481Z--9c146d53758416334ef4556d9060d641fcd1711c
|-- Makefile
|-- README.md
+-- TT.txt

Never mind the TT.txt file. this is just a temp file where the hash value is
kept.

The ```keystore``` and ```docs``` folders are created when they do not exist.
In keystore you find the active private key and your pw file. **Please make sure you protect these files** .

In ```./docs``` you can store the files that you want to create a hash for or
that you would like to sign. The file ```somefile.pdf``` is just an example.

## External libraries used

This also comes with a function to sign a hash (keccak-256sum) of any binary
file. The docker will download and build all required tools. For more details
on this tools. Check:

* [https://github.com/maandree/libkeccak](https://github.com/maandree/libkeccak)
* [https://github.com/maandree/sha3sum](https://github.com/maandree/sha3sum)

These little usefull projects are provided by Mattias Andrée (github: maandree).
I would like to thank Mattias for his contribution. All projects (libkeccak and
sha3sum) are under ISC license.

## Make files and use details

All commands are wrapped in a Makefile. You require the following:

* docker 18.03 or better
* GNU Make 3.81 or better

## First time setup

This will build the layer that brings the sha3 (keccak-256sum) functionality to
the docker image.

```
make lib
```

## Build your key
make key PASSWD="**< YourPasswd >**"

## Signing
make signature MESSAGE="HELLOWORLD" PASSWD="**< YourPasswd >**"

## Verify
make verify MESSAGE="HELLOWORLD" SIGNATURE="**< SignatureOf-HELLOWORLD >**"

## Signing a binary file
make signbin FILENAME="**< FullPathAndFilename >**" PASSWD="**< YourPasswd >**"

## Verifying a binary file
make verifybin FILENAME="**< FullPathAndFilename >**" SIGNATURE="**< SignatureOf-BinaryFile >**"
