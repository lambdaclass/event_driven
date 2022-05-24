up:
	tilt up
topics:
	docker exec -it redpanda-0 rpk topic create listings escrow --brokers=localhost:9092 -p 3 -r 3

RAND_UUID ?= `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`

api.post.listing:
	curl -X POST localhost:4000/api/item/list -H 'content-type: application/json' -d '{"item_id": "item_id", "buyer_id": "buyer_id", "price": 10}'
api.get.listing.list:
	curl -X GET localhost:4000/api/item/list?test=testing -H 'content-type: application/json'