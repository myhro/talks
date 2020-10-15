DEPLOY_FILE := deploy-k8s.yaml
ENV ?= staging
IMAGE := myhro/talks
TUNNEL ?= ef6c7a3c-18e2-4740-b195-0a59869721f1
VERSION := $(shell git rev-parse --short HEAD)

build:
	docker build -t $(IMAGE) .

clean:
	rm -f $(DEPLOY_FILE)

deploy:
	sed 's/<ENV>/$(ENV)/;s/<TUNNEL>/$(TUNNEL)/;s/<VERSION>/$(VERSION)/' kubernetes.yaml > $(DEPLOY_FILE)
	kubectl apply -f $(DEPLOY_FILE)

deps:
	go get -u golang.org/x/tools/cmd/present

push:
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

serve:
	@present
