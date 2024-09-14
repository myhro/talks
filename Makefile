BRANCH ?= staging
DIST_FOLDER = dist
GOBIN ?= $(shell go env GOPATH)/bin
PRESENT_CMD = $(GOBIN)/present -content slides/ -use_playground
URL = 127.0.0.1:3999

build: clean serve-background mirror stop

clean:
	rm -rf $(DIST_FOLDER)/

deploy:
	npx wrangler pages deploy --branch $(BRANCH) --project-name myhro-talks $(DIST_FOLDER)/

mirror:
	wget --mirror --adjust-extension $(URL)
	wget -O $(URL)/static/styles.css $(URL)/static/styles.css
	mv $(URL)/ $(DIST_FOLDER)/
	echo "<h1>Not Found</h1>" > $(DIST_FOLDER)/404.html

present:
	go install golang.org/x/tools/cmd/present@v0.17.0

serve:
	$(PRESENT_CMD)

serve-background:
	$(PRESENT_CMD) &
	timeout 10s bash -c 'until curl -I $(URL); do sleep 0.5; done'

stop:
	pkill present
