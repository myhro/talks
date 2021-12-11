DEPLOY_FILE := deploy-k8s.yaml
ENV ?= staging
IMAGE := myhro/talks
PRESENT_VERSION = v0.1.8
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
# Downloading the binary isn't enough on Go >= 1.16, the source is needed as well
# https://github.com/golang/go/issues/43459#issuecomment-800654748
	go install golang.org/x/tools/cmd/present@$(PRESENT_VERSION)
	go get -d golang.org/x/tools/cmd/present@$(PRESENT_VERSION)

push:
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

serve:
	@present -base $(GOPATH)/pkg/mod/golang.org/x/tools@$(PRESENT_VERSION)/cmd/present
