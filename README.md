# Off-chain signing using Ethereum keys

This little utility help you make build a Ethereum based key-pair.  With this
key you can sign messages that people can verify by just using your public key.

All commands are wrapped in a Makefile. You require the following:

* docker 18.03 or better
* GNU Make 3.81 or better

## Build your key
make build key export PASSWD="<YourPasswd>"

## Start with existing key
make build import

## Signing
make signature MESSAGE="HELLOWORLD" PASSWD="<YourPasswd>"
