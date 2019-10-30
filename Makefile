VERSION = $(shell cat VERSION)
DOCKER_ORG = bluesteelabm
WS_RELAY_DIR = docker/dev/ws-tcp-relay
WS_RELAY_CODE_NAME = code
WS_RELAY_CODE_DIR = $(WS_RELAY_DIR)/$(WS_RELAY_CODE_NAME)
WS_RELAY_REPO = git@github.com:isobit/ws-tcp-relay.git
WS_RELAY_VERSION = 0.2.0
WS_RELAY_RENAME = nats-relayd

default: up

up:
	@VERSION=$(VERSION) RELAYD_VERSION=$(WS_RELAY_VERSION) \
	docker-compose -f ./docker/dev/compose.yml up

rebuild:
	@VERSION=$(VERSION) RELAYD_VERSION=$(WS_RELAY_VERSION) \
	docker-compose -f ./docker/dev/compose.yml build

rebuild-up: rebuild up

down:
	@VERSION=$(VERSION) RELAYD_VERSION=$(WS_RELAY_VERSION) \
	docker-compose -f ./docker/dev/compose.yml down

check-cluster:
	@curl --silent http://localhost:8222/varz | jq .connect_urls

install-clients:
	@go get github.com/nats-io/go-nats-examples/tools/nats-pub
	@go get github.com/nats-io/go-nats-examples/tools/nats-sub

test-sub:
	@nats-sub -s "nats://localhost:4222" hello

test-pub:
	@nats-pub -s "nats://localhost:24222" hello world

$(WS_RELAY_CODE_DIR):
	@cd $(WS_RELAY_DIR) && \
	git clone $(WS_RELAY_REPO) $(WS_RELAY_CODE_NAME) && \
	git checkout v$(WS_RELAY_VERSION)

$(WS_RELAY_RENAME): $(WS_RELAY_CODE_DIR)
	@docker build -t $(DOCKER_ORG)/$(WS_RELAY_RENAME):$(WS_RELAY_VERSION) $(WS_RELAY_DIR)

images: $(WS_RELAY_RENAME)

tags:
	@docker tag $(DOCKER_ORG)/$(WS_RELAY_RENAME):$(WS_RELAY_VERSION) \
	$(DOCKER_ORG)/$(WS_RELAY_RENAME):latest

dockerhub: tags
	@docker push $(DOCKER_ORG)/$(WS_RELAY_RENAME):$(WS_RELAY_VERSION)
	@docker push $(DOCKER_ORG)/$(WS_RELAY_RENAME):latest

clean-docker:
	@docker system prune -f