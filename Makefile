VERSION = $(shell cat VERSION)

default: up

up:
	@VERSION=$(VERSION) docker-compose -f ./docker/dev/compose.yml up

down:
	@VERSION=$(VERSION) docker-compose -f ./docker/dev/compose.yml down

bash:
	@docker exec -it messaging bash
