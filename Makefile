IMAGE = myhro/talks
VERSION := $(shell git rev-parse --short HEAD)

build:
	docker build -t $(IMAGE) .

deploy:
	sed -i 's/IMAGE_VERSION/$(VERSION)/' kubernetes.yaml
	kubectl apply -f kubernetes.yaml

deps:
	go get -u golang.org/x/tools/cmd/present

push:
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

serve:
	@present
