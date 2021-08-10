.PHONY: help
PROJECT_NAME ?= remittance
DOCKER_DEV_COMPOSE_FILE := docker-compose.yml
TARGET_MAX_CHAR_NUM=10

# a variable that stores application's container id if the container is running
CONTAINER_ID := $(shell docker-compose -f docker-compose.yml ps -q remittance)
ifeq ($(CONTAINER_ID),)
	CONTAINER := $(shell docker-compose -f docker-compose.yml ps -q remittance)
else
	CONTAINER := $(shell docker ps -q --no-trunc | grep $$(docker-compose -f docker-compose.yml ps -q remittance))
endif

# function that displays an error to user if the application is not running
define container_err
	${INFO} "Please execute \"make start\" on a different terminal tab."
endef

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '${YELLOW} make ${RESET} ${GREEN}<target> [options]${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		message = match(lastLine, /^## (.*)/); \
		if (message) { \
			command = substr($$1, 0, index($$1, ":")-1); \
			message = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} %s\n", command, message; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

## Start local development server containers
start:
	@ ${INFO} "Starting the application"

	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) up --build

## Run commands
run:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Running $(command)"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec \
		remittance $(command)
endif

## Run tests against the application
test:
	@ ${INFO} "Building the container and running tests"

	@ docker-compose --env-file test.env -f $(DOCKER_DEV_COMPOSE_FILE) up -d db && \
	  docker-compose --env-file test.env -f $(DOCKER_DEV_COMPOSE_FILE) up --build remittance && \
	  docker-compose --env-file test.env -f $(DOCKER_DEV_COMPOSE_FILE) down -v

## Stop local development server containers and remove volumes
stop:
	${INFO} "Stop development server containers"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) down -v
	${INFO} "All containers stopped successfully"

## [ service ] Ssh into service container
ssh:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Open app container terminal"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec $(service) sh
endif

## Initialize db migrations
migrations-init:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Initializing db migrations"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec \
		remittance flask db init
endif

## Run migrations
db-migrations:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Running migrations"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec \
		remittance flask db migrate
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec \
		remittance flask db upgrade
endif

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
NC := "\e[0m"
RESET  := $(shell tput -Txterm sgr0)
# Shell Functions
INFO := @bash -c 'printf "\n"; printf $(YELLOW); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
SUCCESS := @bash -c 'printf "\n"; printf $(GREEN); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
