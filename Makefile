DEPLOY_FILE := deploy-k8s.yaml
ENV ?= staging
HOST ?= talks.myhro.net
IMAGE := myhro/talks
VERSION := $(shell git rev-parse --short HEAD)

build:
	docker build -t $(IMAGE) .

clean:
	rm -f $(DEPLOY_FILE)

deploy:
	sed 's/<ENV>/$(ENV)/;s/<HOST>/$(HOST)/;s/<VERSION>/$(VERSION)/' kubernetes.yaml > $(DEPLOY_FILE)
	kubectl apply -f $(DEPLOY_FILE)

deps:
	go get -u golang.org/x/tools/cmd/present

push:
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

serve:
	@present
