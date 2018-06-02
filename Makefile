NAME=ethsign
GETHVERSION=v1.8.10
KEYS=/root/.ethereum/keystore

lib:
	docker build -t yellowbrainz/signer:latest .

hash:
	docker run -v `pwd`/docs:/opt yellowbrainz/signer:latest /opt/$(FILENAME) | cut -c 1-64

key:
	@if [ ! -d ./keystore ]; then mkdir -p keystore; else rm -f ./keystore/UTC*; fi
	@if [ -e ./keystore/pw ]; then PASSWD= $(cat ./keystore/pw); else echo "$(PASSWD)" > ./keystore/pw; fi
	@chmod 400 ./keystore/pw
	@docker run --name $(NAME) -ti --volume `pwd`/keystore:$(KEYS) ethereum/client-go:$(GETHVERSION) --password $(KEYS)/pw account new
	@docker rm $(NAME) >/dev/null

signature:
	@docker run -d --name $(NAME) --volume `pwd`/keystore:$(KEYS) ethereum/client-go:$(GETHVERSION) >/dev/null
	@sleep 5
	@docker exec $(NAME) geth attach --exec "personal.sign(web3.toHex('$(MESSAGE)'),eth.accounts[0],'$(PASSWD)');"
	@docker stop $(NAME) >/dev/null
	@docker rm $(NAME) >/dev/null

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
