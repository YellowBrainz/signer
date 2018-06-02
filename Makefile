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

signbin:
	docker start $(NAME) >/dev/null
	sleep 5
	keccak-256sum $(FILE) |cut -c 1-64 >TT.txt
	cat TT.txt |sed 's/^/hash\=\"0x/' >TTT.txt
	echo '"' >>TTT.txt
	cat TTT.txt |tr -d '\n' >TT.js
	cat TT.js
	echo ""
	docker cp TT.js $(NAME):/
	docker exec $(NAME) geth attach --exec "loadScript('TT.js');personal.sign(hash,eth.accounts[0],'$(PASSWD)');"
	rm TT.js
	rm TT.txt
	rm TTT.txt
	docker stop $(NAME) >/dev/null

verifybin:
	docker start $(NAME) >/dev/null
	sleep 5
	keccak-256sum $(FILE) |cut -c 1-64 >VV.txt
	cat VV.txt |sed 's/^/hash\=\"0x/' >VVV.txt
	echo '"' >>VVV.txt
	cat VVV.txt |tr -d '\n' >VV.js
	docker cp VV.js $(NAME):/
	docker exec $(NAME) geth attach --exec "loadScript('VV.js');eth.accounts[0] == personal.ecRecover(hash,'$(SIGNATURE)');"
	rm VV.js
	rm VV.txt
	rm VVV.txt
	docker stop $(NAME) >/dev/null