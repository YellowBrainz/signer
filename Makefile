NAME=ethsign

build:
	- docker rm -f $(NAME)
	docker run -d --name $(NAME) ethereum/client-go --maxpeers 0
	sleep 5
	docker cp ./src/verify.js $(NAME):/root/.ethereum
	docker stop $(NAME)

key:
	docker start $(NAME)
	echo "$(PASSWD)" > pw
	docker cp pw $(NAME):/
	docker exec $(NAME) geth --password pw account new
	docker exec $(NAME) rm pw
	rm pw
	docker stop $(NAME)

import:
	docker cp keystore/* $(NAME):/root/.ethereum/keystore/

export:
	docker cp $(NAME):/root/.ethereum/keystore .

signature:
	docker start $(NAME)
	sleep 5
	docker exec  $(NAME) geth attach --exec "personal.sign(web3.toHex('$(MESSAGE)'),eth.accounts[0],'$(PASSWD)');"
	docker stop $(NAME)

verify:
	docker start $(NAME)
	sleep 5
	docker exec $(NAME) geth attach --exec "eth.accounts[0] == personal.ecRecover(web3.toHex('$(MESSAGE)'),'$(SIGNATURE)');"
	docker stop $(NAME)