NAME=ethsign

build:
	- docker rm -f $(NAME) >/dev/null
	docker run -d --name $(NAME) ethereum/client-go --maxpeers 0 >/dev/null
	sleep 5
	docker stop $(NAME) >/dev/null

key:
	docker start $(NAME) >/dev/null
	echo "$(PASSWD)" > pw
	docker cp pw $(NAME):/ >/dev/null
	docker exec $(NAME) geth --password pw account new >/dev/null
	docker exec $(NAME) rm pw >/dev/null
	rm pw >/dev/null
	docker stop $(NAME) >/dev/null

import:
	docker cp keystore/* $(NAME):/root/.ethereum/keystore/

export:
	docker cp $(NAME):/root/.ethereum/keystore .

signature:
	docker start $(NAME) >/dev/null
	sleep 5
	docker exec  $(NAME) geth attach --exec "personal.sign(web3.toHex('$(MESSAGE)'),eth.accounts[0],'$(PASSWD)');"
	docker stop $(NAME) >/dev/null

verify:
	docker start $(NAME) >/dev/null
	sleep 5
	docker exec $(NAME) geth attach --exec "eth.accounts[0] == personal.ecRecover(web3.toHex('$(MESSAGE)'),'$(SIGNATURE)');"
	docker stop $(NAME) >/dev/null