ENV ?= staging
PRESENT_CMD = $(GOBIN)/present -base $(GOPATH)/pkg/mod/golang.org/x/tools@$(PRESENT_VERSION)/cmd/present -content slides/ -use_playground
PRESENT_VERSION = v0.1.8
URL = 127.0.0.1:3999

build: clean serve-background mirror stop

clean:
	rm -rf dist/

deps:
	go install golang.org/x/tools/cmd/present@$(PRESENT_VERSION)

deploy:
	npx wrangler publish --env $(ENV)

dev:
	npx wrangler dev

mirror:
	wget --mirror --adjust-extension $(URL)
	wget -O $(URL)/static/styles.css $(URL)/static/styles.css
	mv $(URL)/ dist/

serve:
	$(PRESENT_CMD)

serve-background:
	$(PRESENT_CMD) &
	timeout 10s bash -c 'until curl -I $(URL); do sleep 0.5; done'

stop:
	pkill present
