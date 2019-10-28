VERSION = $(shell cat VERSION)
WS_RELAY_DIR = docker/dev/ws-tcp-relay
WS_RELAY_CODE_NAME = code
WS_RELAY_CODE_DIR = $(WS_RELAY_DIR)/$(WS_RELAY_CODE_NAME)
WS_RELAY_REPO = git@github.com:isobit/ws-tcp-relay.git

default: up

up:
	@VERSION=$(VERSION) docker-compose -f ./docker/dev/compose.yml up

rebuild:
	@VERSION=$(VERSION) docker-compose -f ./docker/dev/compose.yml build

rebuild-up: rebuild up

down:
	@VERSION=$(VERSION) docker-compose -f ./docker/dev/compose.yml down

bash:
	@docker exec -it messaging bash

$(WS_RELAY_CODE_DIR):
	@cd $(WS_RELAY_DIR) && git clone $(WS_RELAY_REPO) $(WS_RELAY_CODE_NAME)

nats-relay-img: $(WS_RELAY_CODE_DIR)
	@docker build -t bluesteelabm/nats-relay:$(VERSION) $(WS_RELAY_DIR)

clean-docker:
	@docker system prune -f