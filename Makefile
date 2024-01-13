GOBIN ?= $(shell go env GOPATH)/bin
PRESENT_CMD = $(GOBIN)/present -content slides/ -use_playground
URL = 127.0.0.1:3999

build: clean serve-background mirror stop

clean:
	rm -rf dist/

deps:
	go install golang.org/x/tools/cmd/present@v0.17.0

dev:
	BROWSER=none npx wrangler pages dev dist/

mirror:
	wget --mirror --adjust-extension $(URL)
	wget -O $(URL)/static/styles.css $(URL)/static/styles.css
	mv $(URL)/ dist/
	echo "<h1>Not Found</h1>" > dist/404.html

serve:
	$(PRESENT_CMD)

serve-background:
	$(PRESENT_CMD) &
	timeout 10s bash -c 'until curl -I $(URL); do sleep 0.5; done'

stop:
	pkill present
