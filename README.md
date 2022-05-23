# Event Driven PoC

## Dependencies

- Docker
- [Tilt](https://tilt.dev/)
- Elixir

## Usage

Run

```
make up
```

to setup all the services, the Redpanda cluster and the postgres instance. Once everything is up, do

```
make topics
```

to create the kafka topics to be used by the services.

You can then call the `buy` endpoint like so:

```
curl -X POST localhost:4000/api/item/list -H 'content-type: application/json' -d '{"item_id": "some_item_id", "price": 10, "buyer_id": "some_id"}'
```

## High level idea

### Writes
![writes](https://user-images.githubusercontent.com/49622509/168887448-316b537c-8909-4d82-8821-b4f661a54d0a.png)

### Reads
![reads](https://user-images.githubusercontent.com/49622509/168884498-763a1bdf-bf69-4b14-9d4e-fdedf4d8cb78.png)
