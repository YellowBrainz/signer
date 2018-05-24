NAME=etcsign

build:
	- docker rm -f $(NAME)
	docker run -d --name $(NAME) ethereum/client-go --maxpeers 0
	sleep 5
	docker stop $(NAME)

key:
	docker start $(NAME)
	docker exec $(NAME) touch pw
	docker exec $(NAME) geth --password pw account new
	docker stop $(NAME)

import:
	docker cp keystore/* $(NAME):/root/.ethereum/keystore/

export:
	docker cp $(NAME):/root/.ethereum/keystore .

signature:
	docker start $(NAME)
	docker exec  $(NAME) geth attach --exec "personal.unlockAccount(eth.accounts[0],''); web3.eth.sign(eth.accounts[0], web3.toHex('#' + '$(MESSAGE)').replace('0x23','0x'));"
	docker stop $(NAME)
