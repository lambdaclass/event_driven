up:
	tilt up
topics:
	docker exec -it redpanda-0 rpk topic create listings escrow --brokers=localhost:9092 -p 3 -r 3
