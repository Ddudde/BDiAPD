MODULES = faker
MODULEDIR=extension/faker
EXTENSION = faker
EXTENSION_VERSION=$(shell grep default_version $(EXTENSION).control | sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")
EXTENSION_FILE=faker--$(EXTENSION_VERSION).sql
DATA = $(EXTENSION_FILE)
REGRESS = init seed schema parameters localized unique
REGRESS_OPTS = --inputdir=tests
EXTRA_CLEAN = _build _venv $(ZIPBALL)
OBJS = faker.o

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

##
## H E L P
##

default:: help

help::  #: display this message.
	@echo
	@echo "Available targets for $(EXTENSION) $(EXTENSION_VERSION):"
	@echo
	@gawk 'match($$0, /([^:]*):.+#'': (.*)/, m) { printf "    %-16s%s\n", m[1], m[2]}' $(MAKEFILE_LIST) | sort
	@echo

##
## L I N T
##

.PHONY: lint
lint: lint-md lint-py #: run all syntax checks

.PHONY: lint-py
lint-py: | _venv #: Check the python syntax
	_venv/bin/python -m flake8 faker

.PHONY: lint-md
lint-md: #: Check the markdown syntax
	mdl *.md

##
## B U I L D
##

#all: extension

.PHONY: extension
extension: $(EXTENSION_FILE) #: build the extension

$(EXTENSION_FILE):	faker/init.sql _build/providers.sql | _build
	cat $^ > $@

.INTERMEDIATE: _build/providers.sql
_build/providers.sql: faker/providers.py faker/providers.sql.j2 | _venv _build
	_venv/bin/python3  faker/providers.py > $@

_venv:
	# Pinning to 3.6 because of Faker 6.1.1 is not compatible with Python 3.8.10+
	# https://github.com/joke2k/faker/issues/1439
	#python3 -m venv $@
	virtualenv $@ --python=python3.6
	$@/bin/pip install --upgrade pip
	$@/bin/pip install -r requirements.txt


_build:
	mkdir -p _build


##
## P G X N
##

ZIPBALL:=$(EXTENSION)-$(EXTENSION_VERSION).zip

$(ZIPBALL): pgxn

pgxn: extension #: build the PGXN package
	zip -r $(ZIPBALL) $(DATA) faker.control META.json Makefile faker.c


##
## D O C K E R
##

docker_image: docker/Dockerfile #: build the docker image
	docker build -t registry.gitlab.com/dalibo/postgresql_faker . --file $^

docker_push: #: push the docker image to the registry
	docker push registry.gitlab.com/dalibo/postgresql_faker

docker_bash: #: enter the docker image (useful for testing)
	docker exec -it docker_postgresql_faker_1 bash

COMPOSE=docker-compose --file docker/docker-compose.yml

docker_init: #: start a docker container
	$(COMPOSE) down --remove-orphans
	$(COMPOSE) up -d
	@echo "The Postgres server may take a few seconds to start. Please wait."
