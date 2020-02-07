# -*- mode: makefile-gmake; indent-tabs-mode: true; tab-width: 4 -*-
SHELL   = bash
mydir  := $(dir $(lastword ${MAKEFILE_LIST}))

REGISTRY=mariannmt

# Docker image tags
BETAG=$(shell git log -1 --abbrev-commit -- build-environment/ | awk '/commit/ { print $$2 }')
MCTAG=$(shell git log -1 --abbrev-commit -- marian-compiled/ | awk '/commit/ { print $$2 }')
RTTAG=$(shell git rev-parse --short HEAD)

image/build-environment: IMAGE=build-environment
image/build-environment: FLAGS=${DOCKER_BUILD_ARGS}
image/build-environment:
	docker build -t ${REGISTRY}/${IMAGE}:${BETAG} ${FLAGS} ${IMAGE}

image/marian-compiled: IMAGE=marian-compiled
image/marian-compiled: FLAGS=${DOCKER_BUILD_ARGS}
image/marian-compiled: FLAGS+=--build-arg BETAG=${BETAG}
image/marian-compiled:
	docker build -t ${REGISTRY}/${IMAGE}:${MCTAG} ${FLAGS} ${IMAGE}

image/marian-rest-server: IMAGE=marian-rest-server
image/marian-rest-server: FLAGS=${DOCKER_BUILD_ARGS}
image/marian-rest-server: FLAGS+=--build-arg MCTAG=${MCTAG}
image/marian-rest-server:
	docker build -t ${REGISTRY}/${IMAGE}:${RTTAG} ${FLAGS} ${IMAGE}
	docker tag ${REGISTRY}/${IMAGE}:${RTTAG} ${REGISTRY}/${IMAGE}:latest