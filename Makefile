NAME = sprack/docker-raspi-cncjs
VERSION = $(shell cat VERSION)
CNCJS_VER ?= $(VERSION)

.PHONY: all build tag_latest push

all: build tag_latest push

build:
	docker build --rm --build-arg CNCJS_VER=$(CNCJS_VER) -t $(NAME):$(VERSION) .

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

