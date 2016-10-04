ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent

list:
	sh -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

all: build

build:
	@docker build --tag=hrektts/fusiondirectory:latest .

release: build
	@docker build --tag=hrektts/fusiondirectory:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t hrektts/fusiondirectory:bats .
	bats test

#######################
# Docker machine states
#######################

up:
	docker-compose up -d

start:
	docker-compose start

stop:
	docker-compose stop

state:
	docker-compose ps

rebuild:
	docker-compose stop
	docker-compose rm --force openldap
	docker-compose rm --force fusiondirectory
	docker-compose build --no-cache
	docker-compose up -d

restart:
	docker-compose stop
	docker-compose start

#############################
# Argument fix workaround
#############################
%:
	@: